# Lab 8: Meta-Arguments

Duration: 10 minutes

So far, we've already used arguments to configure your resources. These arguments are used by the provider to specify things like the image to use, and the type of instance to provision. Terraform also supports a number of _Meta-Arguments_, which changes the way Terraform configures the resources. For instance, it's not uncommon to provision multiple copies of the same resource. We can do that with the _count_ argument.

- Task 1: Change the number of Google instances with `count`
- Task 2: Modify the rest of the configuration to support multiple instances
- Task 3: Add variable interpolation to the count arguement

## Task 1: Change the number of Google Compute instances with `count`

### Step 8.1.1

Add a count argument to the Google instance in `server/server.tf` with a value of 2.  Also adjust the value of `name` to incrementally add a number to the end of each instances name: 

```hcl
# ...
resource "google_compute_instance" "web" {
  count        = 2
  name         = "${var.name}${count.index + 1}"
  machine_type = "f1-micro"
# ... leave the rest of the resource block unchanged...
}
```

## Task 2: Modify the rest of the configuration to support multiple instances

### Step 8.2.1

If you run `terraform apply` now, you'll get an error. Since we added _count_ to the google_compute_instance.web resource, it now refers to multiple resources. Because of this, values like our public_ip output no longer refer to the "public ip" of a single resource. We need to tell terraform which resource we're referring to.

To do so, modify the output blocks in `server/server.tf` as follows:

```hcl
output "public_ip" {
  value = google_compute_instance.web[*].network_interface[0].access_config[0].nat_ip
}
```

The syntax `google_compute_instance.web[*]...` refers to all of the instances, so this will output a list of all of the public IPs. 

### Step 8.2.2

Run `terraform apply` to add the new instance. You should see two IP addresses in the outputs.

## Task 3: Add variable interpolation to the count arguement

### Step 8.3.1

Update `server/server.tf` to add a new variable definition, and use it:

```hcl
# ...
variable "num_webs" {
  default = 2
}

resource "google_compute_instance" "web" {
  count        = var.num_webs
  name         = "${var.name}${count.index + 1}"
  machine_type = "f1-micro"
# ...
```

The solution builds on our previous discussion of variables. We must create a
variable to hold our count so that we can reference that count in our
resource. Next, we replace the value of the count parameter with the variable
interpolation. Finally, we interpolate the current count (+ 1 because it's
zero-indexed) and the variable itself.

Remember to also add the variable declaration to your `main.tf` and `terraform.tfvars` accordingly.

### Step 8.3.2

Run `terraform apply` in the terraform directory. No changes should be detected as the _values_ have not changed:

```shell
terraform apply
```

```text
No changes. Infrastructure is up-to-date.

This means that Terraform did not detect any differences between your
configuration and real physical resources that exist. As a result, no
actions need to be performed.
```