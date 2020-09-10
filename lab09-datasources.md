# Lab 9: Data Source (Optional)

This is an optional lab that you can perform on your own at the end of the Terraform 101 course if you have time.  It uses the [google_compute_image](https://www.terraform.io/docs/providers/google/d/compute_image.html) data source to fetch the same image that we have been using all along and then makes the google_compute_instance web use that image. You can read about data sources [here](https://www.terraform.io/docs/configuration/data-sources.html). An example of making an google_compute_instance resource use the image returned by an google_compute_image data source is in the [google_compute_instance](https://www.terraform.io/docs/providers/google/d/compute_image.html) resource documentation.

Duration: 10 minutes

- Task 1: Add an google_compute_image data source
- Task 2: Make the google_compute_instance web use the image returned by the data source

## Task 1: Add an google_compute_image data source

### Step 9.1.1

Add an google_compute_image data source called "debian-9" in server/server.tf after the
variable definitions. It will find the most recent instance of a Debian 9
image.

```hcl
data "google_compute_image" "debian_9" {
  family  = "debian-9"
  project = "debian-cloud"
}
```

## Task 2: Make the google_compute_instance use the returned image

### Step 9.2.1

Edit the google_compute_instance in server/server.tf so that its image argument uses the image returned by the data source.

```hcl
resource "google_compute_instance" "web" {
  count        = var.num_webs
  name         = "${var.name}${count.index + 1}"
  machine_type = "f1-micro"
  zone         = var.zone
  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian_9.self_link
    }
  }
...
}
```

### Step 9.2.2

Additionally, since we no longer need the image variable, remove it or comment it
out (with initial "#") both in server/server.tf and in main.tf. In the latter,
remove or comment it out both in the variable declaration itself and in the
server module block. You can also comment it out in terraform.tfvars.

### Step 9.2.3

Run `terraform apply` one last time to apply the changes you made.

```shell
terraform apply
```
