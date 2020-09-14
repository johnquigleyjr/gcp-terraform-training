# Lab 6: Provisioners

Duration: 30 minutes

Your workstation has code for provisioning the webapp onto the instance we've
created. In order for this code to be installed onto the, Terraform can connect
to and provision the instance remotely with a provisioner block.

- Task 1: Add a resource block to generate an SSH keypair
- Task 2: Create a connection block using your keypair outputs.
- Task 3: Create a provisioner block to remotely download code to your instance.
- Task 4: Add a firewall rule to permit SSH and HTTP
- Task 5: Apply your configuration and watch for the remote connection.

## Task 1: Add a resource block to generate an SSH keypair.

### Step 6.1.1

In `server/server.tf`, add a resource block (below your variables section) as follows to generate an SSH keypair:

```hcl
resource "tls_private_key" "ssh-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
```

### Step 6.1.2

Within your google_compute_instance resource block, under "tags", add the following:

```hcl
metadata = {
  ssh-keys = yourname:${tls_private_key.ssh-key.public_key_openssh}"
}
```

### Step 6.1.3

Create a .pem file for your private key using the "local_file" resource.  Add the following resource block to your `server/server.tf`:

```hcl
resource "local_file" "pem" {
    content     = tls_private_key.ssh-key.private_key_pem
    filename = "./keys/private_key.pem"
}
```

### Step 6.1.4

Execute a `terraform init` to install the plugin for the local provider

```shell
terraform init
```

```text
Initializing modules...

Initializing the backend...

Initializing provider plugins...
- Checking for available provider plugins...
- Downloading plugin for provider "local" (hashicorp/local) 1.4.0...
```

## Task 2: Create a connection block using your keypair module outputs.

### Step 6.2.1

In `server/server.tf`, add a connection block within your web instance resource under the tags:

```hcl
resource "google_compute_instance" "web" {
# Leave the first part of the block unchanged, and add a connection block:
# ...

  connection {
    user        = "yourname"
    private_key = tls_private_key.ssh-key.private_key_pem
    host        = self.network_interface[0].access_config[0].nat_ip
  }
```

The value of `self` refers to the resource defined by the current block. So `self.network_interface[0].access_config[0].nat_ip` refers to the public IP address of our `google_compute_instance.web`.

## Task 3: Create a provisioner block to remotely download code to your instance.

### Step 6.3.1

The file provisioner will run after the instance is created and will copy the contents of the _assets_ directory to it. Add this to the _google_compute_instance_ block in `server/server.tf`, right after the connection block you just added:

```hcl
  provisioner "file" {
    source      = "assets"
    destination = "/tmp/"
  }
```

### Step 6.3.2

The remote-exec provisioner runs remote commands. We can execute the script from
our assets directory. Add this after the _file_ provisioner block:

```hcl
  provisioner "remote-exec" {
    inline = [
      "sudo sh /tmp/assets/setup-web.sh",
    ]
  }
```

Make sure both provisioners are inside the _google_compute_instance_ resource block.

## Task 4: Add a firewall rule to permit SSH.

### Step 6.4.1

To enable Terraform to connect to the instance (to execute file and remote-exec provisioners), we must add a firewall rule to permit SSH connections (TCP port 22).  Add the following resource block to your `server/server.tf`:

```hcl
resource "google_compute_firewall" "gcp-externalssh" {
  name    = "gcp-externalssh"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
```

### Step 6.4.2

To enable external http access to your Google Compute instance, we need to create a firewall rule to allow TCP port 80 to your instance.  Add the following to your `server/server.tf`:

```hcl
resource "google_compute_firewall" "gcp-externalhttp" {
  name    = "gcp-externalhttp"
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}
```

## Task 5: Apply your configuration and watch for the remote connection.

### Step 6.5.1

An important point to remember regarding _provisioners_ is that adding or removing them from an instance won't cause terraform to update or recreate the instance. You can see this now if you run `terraform apply`:

```text
...

Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

...
```

In order to ensure that the provisioners run, use the `terraform taint` command. A resource that has been marked as _tainted_ will be destroyed and recreated.

```shell
terraform taint module.server.google_compute_instance.web
```

```
Resource instance module.server.google_compute_instance.web has been marked as tainted.
```

Upon running `terraform apply`, you should see new output:

```shell
terraform apply
```

```text
...
module.server.google_compute_instance.web: Provisioning with 'remote-exec'...
module.server.google_compute_instance.web (remote-exec): Connecting to remote host via SSH...
module.server.google_compute_instance.web (remote-exec):   Host: 34.73.228.205
module.server.google_compute_instance.web (remote-exec):   User: yourname
module.server.google_compute_instance.web (remote-exec):   Password: false
module.server.google_compute_instance.web (remote-exec):   Private key: true
module.server.google_compute_instance.web (remote-exec):   Certificate: false
module.server.google_compute_instance.web (remote-exec):   SSH Agent: false
module.server.google_compute_instance.web (remote-exec):   Checking Host Key: false
module.server.google_compute_instance.web: Still creating... [30s elapsed]
module.server.google_compute_instance.web (remote-exec): Connected!
module.server.google_compute_instance.web (remote-exec): Created symlink from /etc/systemd/system/multi-user.target.wants/webapp.service to /lib/systemd/system/webapp.service.
module.server.google_compute_instance.web: Creation complete after 41s (ID:)

Apply complete! Resources: 1 added, 0 changed, 1 destroyed.
...
```

You can now visit your web application by pointing your browser at the public_ip output for your Google Compute instance. If you want, you can also ssh to your instance with a command like `ssh -i keys/<your_private_key>.pem yourname@<your_ip>`.  Type yes when prompted to use the key. Type `exit` to quit the ssh session.

```shell
ssh -i keys/<your_private_key>.pem yourname@<your_ip>
```

```text
The authenticity of host (54.203.220.176) can't be established.
ECDSA key fingerprint is SHA256:Q/IWQRIOcb1h46ic7mHR2oBCk9XOTPHCHQOy0A/pezs.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added 54.203.220.176 (ECDSA) to the list of known hosts.
Welcome to Ubuntu 16.04.6 LTS (GNU/Linux 4.4.0-1088 x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

0 packages can be updated.
0 updates are security updates.

New release '18.04.2 LTS' available.
Run 'do-release-upgrade' to upgrade to it.


Last login: Fri Aug 16 20:58:44 2019 from 34.222.21.235
user@ip-10-1-1-96:~$ exit
logout
Connection to host closed.
```
