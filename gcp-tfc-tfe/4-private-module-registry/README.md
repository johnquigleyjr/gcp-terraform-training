# Terraform Enterprise - Private Module Registry

## Expected Outcome

In this challenge you will register a module with your Private Module Registry then reference it in a workspace.

## How to:

### Create a Module Repository

Create a new GitHub repository, similar to early labs, with the name "terraform-google-server".

Create a single `main.tf` with the following contents:

```hcl
resource "google_compute_network" "vpc_network" {
  name = var.network
}

resource "google_compute_instance" "web" {
  count        = var.num_webs
  name         = "${var.name}-${count.index + 1}"
  machine_type = "f1-micro"
  zone         = var.zone

  boot_disk {
    initialize_params {
      image = var.image
    }
  }
  network_interface {
    network = google_compute_network.vpc_network.name

    access_config {

    }
  }
  tags = [var.identity,"yourname","env1"]
}
output "public_ip" {
  value = google_compute_instance.web[*].network_interface[0].access_config[0].nat_ip
}
```

Create a `variables.tf` file with the following contents:
```hcl
variable "zone" {}
variable "name" {}
variable "image" {}
variable "identity" {}
variable "num_webs" {}
varialbe "network" {}
```

Commit the changes into GitHub.

### Update github repository

Back in your `workspace` repository created earlier.

Add a new folder called `app-web-modules/`.

Create a single `main.tf` file with the following contents:

```hcl
provider "google" {
  credentials = var.creds
  project = var.project
  region  = var.region
  zone    = var.zone
}
module "server" {
  source = "./server"
  name                   = var.name
  num_webs               = var.num_webs
  image                  = var.image
  identity               = var.identity
  zone                   = var.zone
  network                = var.network
}
```

In your `app-web-modules` folder create a `variables.tf` file with the following contents:

```hcl
variable "project" {}
variable "zone" {}
variable "region" {
  default = "us-east1"
}
variable "image" {}
variable "identity" {}
variable "name" {}
variable "num_webs" {}
variable "creds" {}
variable "network" {}
```

In your `app-web-modules` folder create a `outputs.tf` file with the following contents:

```hcl
output "public_ip" {
  value = google_compute_instance.web[*].network_interface[0].access_config[0].nat_ip
}
```

Update the `source` argument on the module declaration to your TFE hostname and organization.

Commit the file and check the code into github.

### Create a workspace

Create a TFE workspace that uses the VSC connection to load your repository.

Select the repository and name the workspace "tfe-workspace-modules" and select the working directory as "/app-web-modules".

![](img/tfe-new-workspace.png)

### Add Modules

Before we can use our new module, we need to add it to the Private Module Registry.

Navigate back to Terraform Enterprise and click the "Modules" menu at the top of the page. From there click the "+ Add Module" button.

![](img/tfe-add-module.png)

Select the repository you created above ("terraform-google-server").

![](img/tfe-select-module-repo.png)

> Note: You will see your github user name since the repo is in your github account.

Click "Publish Module".

This will query the repository for necessary files and tags used for versioning.

> Note: this could take a few minutes to complete.

Congrats, you are done!

Ok, not really...

We need to tag the repository to be able to publish a version.

```sh
git tag v0.0.1 master
git push origin v0.0.1
```

### Configure Workspace Variables

Navigate back to your "tfe-workspace-modules" workspace.

Set Environment and Terraform Variables for your gcp provider (be sure check the 'sensitive' checkbox to hide the password):

Enter the following into the Variables section.  Your values will differ, but use those values that were in your `terraform.tfvars` file from previous labs.

```sh
project = "terraformtraining1"
zone = "us-east1-b"
image = "debian-cloud/debian-9"
identity = "rpt"
name = "rpt"
num_webs = 2
creds = "<Contents of GCP account.json file>"
network = "terraform-network-initials"
```

### Run a Plan

Click the "Queue Plan" button.

![](img/tfe-queue-plan.png)

Wait for the Plan to complete.

You should see several additions to deploy your networking.

### Apply the Plan (Optional)

Approve the plan and apply it.

Watch the apply progress and complete.

## Extra Credit

1. Make a change to a module repository and tag it in such a way that the change shows in your Private Module Registry.

## Clean Up (if you ran apply)

Navigate to the workspace "Settings" -> "Destruction and Deletion".

Click Queue Destroy Plan.

Once the plan completes, apply it to destroy your infrastructure.

## Resources

- [Private Registries](https://www.terraform.io/docs/registry/private.html)
- [Publishing Modules](https://www.terraform.io/docs/registry/modules/publish.html)
