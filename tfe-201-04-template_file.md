# Lab 4: Template Provider

Duration: 20 minutes

This lab demonstrates how to define and render a text template with the `templatefile` function.

- Task 1: Create a Terraform configuration that contains a template to be rendered
- Task 2: Use `templatefile` function to render variables into the template
- Task 3: How to attach/apply policy (informational/optional)

## Prerequisites

For this lab, we'll assume that you've installed [Terraform](https://www.terraform.io/downloads.html). This example is executed locally and doesn't require any other credentials or other authentication.

## Task 1: Create a Terraform configuration that contains a template to be rendered


### Step 1.1: Create a Terraform configuration

Create a directory for the Terraform configuration. Create a sub-directory for templates. Create a template file.

```shell
mkdir -p ~/lab_4_iam-demo/templates && cd $_
```

```shell
touch iam_policy.json.tpl
```

The name of the template file is completely up to you. We like to include `tpl` to identify it as a template, but also use a suffix that corresponds to the file type of the contents (such as `json`).

### Step 4.1.2: Write contents of template with some placeholders for variables

In the file we just created, let's create a standard JSON policy file that will assign multiple users to roles. We can define the resource through Terraform interpolation and define those variables outside the template and avoid hardcoding variables into our policies for added usability.

Terraform interpolation syntax is used (such as `${role_name}`). No prefix is needed (`var.` or `data.` or any other).

```json
{
  "bindings": [
    {
      "members": [
        "user:joe@example.com"
      ],
      "role": "roles/storage.objectViewer"
    },
    {
      "members": [
        "user:steve@example.com",
        "user:mark@example.com"
      ],
      "role": "roles/${role_name}"
    }
  ],
  "etag": "BwUjMhCsNvY=",
  "version": 1
}
```

## Task 2: Use `templatefile` function to render variable values into the template

We'll write HCL code to render the template. Let's create a file named `main.tf` in the project folder and reference the template we just created.

```shell
cd ..
```

```shell
touch main.tf
```

### Step 4.2.1: Define the `templatefile` function as a `local`

The local value used here will allow `templatefile` function (created and published by HashiCorp) to be referenced as a variable later.

Pass in the `role_name` variable.

```hcl
locals {
  policy = templatefile("${path.module}/templates/iam_policy.json.tpl", {
    role_name = var.role_name
  })
}
```

We also use `path.module` here for robustness in any module or submodule.

### Step 4.2.2: Pass variables into the template

Create a variable with the value you want to pass into the template. This value could be provided externally, fetched from a data source, or even hard-coded.

Templates do not have access to all variables in a configuration. They must be explicitly passed with the `vars` block.

```hcl
variable "role_name" {
  default = "storage.objectCreator"
}

locals {
  policy = templatefile("${path.module}/templates/iam_policy.json.tpl", {
    role_name = var.role_name
  })
}
```

### Step 4.2.3: Render the template into an output

Rendered template content may be used anywhere: as arguments to a module or resource, or executed remotely as a script. In our case, we'll emit it as an output for easy viewing.

The `templatefile` function can be referenced as a `local` :

```hcl
output "iam_policy" {
  value = local.policy
}
```

### Step 4.2.4: Run the code

Run the code with `terraform apply` and you will see the rendered template.

```shell
terraform init
```

```shell
terraform apply
```

```
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

iam_policy = {
  "bindings": [
    {
      "members": [
        "user:joe@example.com"
      ],
      "role": "roles/storage.objectViewer"
    },
    {
      "members": [
        "user:steve@example.com",
        "user:mark@example.com"
      ],
      "role": "roles/storage.objectCreator"
    }
  ],
  "etag": "BwUjMhCsNvY=",
  "version": 1
}
```

## Task 3: How to attach/apply policy (informational/optional)

The `templatefile` function can also be used to output to a new file.  The resulting file can then be applied to Google Cloud entity (organizations, projects, objects, etc).

### Step 4.3.1: Output to a JSON file

Add a new `local_file` resource to your `main.tf`:

```hcl
resource "local_file" "json_output" {
  filename = "${path.module}/JSON/iam_policy.json"
  content  = local.policy
}
```

### Step 4.3.2: Examples of how to apply the resulting policy

Using `gcloud` (sets IAM policy at the specified project level):

```shell
gcloud projects set-iam-policy example-project-id-1 iam_policy.json
```

Using REST API:

```shell
POST https://cloudresourcemanager.googleapis.com/v1/projects/{resource}:setIamPolicy
```

For more information:

https://cloud.google.com/sdk/gcloud/reference/projects/set-iam-policy

https://cloud.google.com/resource-manager/reference/rest/v1/projects/setIamPolicy

To generate and reference IAM policy natively in Terraform, see [the following guide](https://www.terraform.io/docs/providers/google/d/iam_policy.html) on setting up a google_iam_policy
 datasource.
