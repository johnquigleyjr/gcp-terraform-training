# Lab 1: Lab Setup

Duration: 20 minutes

- Task 1: Connect to the Student Workstation
- Task 2: Verify Terraform installation
- Task 3: Generate your first Terraform Configuration
- Task 4: Use the Terraform CLI to Get Help
- Task 5: Apply and Update your Configuration

## Task 1: Connect to the Student Workstation

In the previous lab, you learned how to connect to your workstation with either VSCode, SSH, or the web-based client.

One you've connected, make sure you've navigated to the `/workstation/terraform` directory. This is where we'll do all of our work for this training.

## Task 2: Verify Terraform installation

### Step 1.2.1

Run the following command to check the Terraform version:

```shell
terraform -version
```

You should see:

```text
Terraform v0.12.6
```

## Task 3: Generate your first Terraform Configuration

### Step 1.3.1

In the /workstation/terraform directory, first rename your existing `main.tf` to `aws.tf.example` and then create a file titled `main.tf` to create a GCP instance.

Your final `main.tf` file should look similar to this with different values:

```hcl
provider "google" {
  credentials = file("account.json")
  project = "<YOUR_GCP_PROJECT>"
  region  = "us-east1"
  zone    = "us-east1-b"
}

resource "google_compute_network" "vpc_network" {
  name = "terraform-network"
}

resource "google_compute_instance" "web" {
  name           = "<initials>-web"
  machine_type = "f1-micro"
  zone         = "us-east1-b"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
  
    network_interface {
      network = google_compute_network.vpc_network.name

      access_config {

    }
  }
  tags = ["<IDENTITY>"]
}
```

Don't forget to save the file before moving on!

## Task 4: Use the Terraform CLI to Get Help

### Step 1.4.1

Execute the following command to display available commands:

```shell
terraform -help
```

```text
Usage: terraform [-version] [-help] <command> [args]

The available commands for execution are listed below.
The most common, useful commands are shown first, followed by
less common or more advanced commands. If you're just getting
started with Terraform, stick with the common commands. For the
other commands, please read the help and docs before usage.

Common commands:
    apply              Builds or changes infrastructure
    console            Interactive console for Terraform interpolations
    destroy            Destroy Terraform-managed infrastructure
    env                Workspace management
    fmt                Rewrites config files to canonical format
    get                Download and install modules for the configuration
    graph              Create a visual graph of Terraform resources
    import             Import existing infrastructure into Terraform
    init               Initialize a Terraform working directory
    output             Read an output from a state file
    plan               Generate and show an execution plan

    ...
```
* (full output truncated for sake of brevity in this guide)


Or, you can use short-hand:

```shell
terraform -h
```

### Step 1.4.2

Navigate to the Terraform directory and initialize Terraform
```shell
cd /workstation/terraform
```

```shell
terraform init
```

```text
Initializing provider plugins...
...

Terraform has been successfully initialized!
```

### Step 1.4.3

Get help on the `plan` command and then run it:

```shell
terraform -h plan
```

```shell
terraform plan
```

## Task 5: Apply and Update your Configuration

### Step 1.5.1

Run the `terraform apply` command to generate real resources in GCP

```shell
terraform apply
```

You will be prompted to confirm the changes before they're applied. Respond with
`yes`.

### Step 1.5.2

Use the `terraform show` command to view the resources created and find the IP address for your instance.

Ping that address to ensure the instance is running.

### Step 1.5.3

Terraform can perform in-place updates on your instances after changes are made to the `main.tf` configuration file.

Add two tags to the GCP instance:

- Name
- Environment

```hcl
  tags = ["Identity", "YourName", "Environment"]
```

### Step 1.5.4

Plan and apply the changes you just made and note the output differences for additions, deletions, and in-place changes.

```shell
terraform apply
```

You should see output indicating that _google_compute_instance.web_ will be modified:

```text
...

# google_compute_instance.web will be updated in-place
~ resource "google_compute_instance" "web" {

...
```

When prompted to apply the changes, respond with `yes`.
