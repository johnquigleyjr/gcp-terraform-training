# Lab 5: Multi-provider

Duration: 15 minutes

This lab demonstrates how several providers can be used together.

- Task 1: Add an AWS provider to your existing GCP code
- Task 2: Deploy an AWS EC2 instance alongside your GCP instance

## Prerequisites

For this lab, we'll assume that you have defined your AWS credentials in your environment. See [Configuring the AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-environment.html) in the AWS docs for details.

```bash
export AWS_ACCESS_KEY_ID="AAAAAA"
export AWS_SECRET_ACCESS_KEY="XXXXXXXX"
export AWS_DEFAULT_REGION="us-west-2"
```

**NOTE:** If you're taking this class in a HashiCorp-led training session, your workstation will already have these variables set, or can be loaded with `source ~/.config/envs/aws`.


## Task 1: Add an AWS provider to your existing GCP code

In the /workstation/terraform directory, rename the file titled `aws.tf.example` to `aws.tf`.  This Terraform code will create an AWS instance, referencing the following properties available in the comments at the top of the file:

- ami
- subnet_id
- vpc_security_group_ids
- tags.Identity

Your final `aws.tf` file should look similar to this with different values specific to your workstation/environment:
)

```hcl
provider "aws" {
  access_key = "<YOUR_ACCESSKEY>"
  secret_key = "<YOUR_SECRETKEY>"
  region     = "<REGION>"
}

resource "aws_instance" "web" {
  ami           = "<AMI>"
  instance_type = "t2.micro"

  subnet_id              = "<SUBNET>"
  vpc_security_group_ids = ["<SECURITY_GROUP>"]

  tags = {
    "Identity" = "<IDENTITY>"
  }
}
```

## Task 2: Deploy an AWS EC2 instance alongside your GCP instance

After populating the values in the AWS provider and aws_instance blocks, you will be able to deploy an AWS EC2 instance.

### Step 5.2.1: Initialize Terraform and apply

```shell
terraform init
```

```text
Initializing provider plugins...
...

Terraform has been successfully initialized!
```

Run the `terraform apply` command to generate real resources in AWS

```shell
terraform apply
```

You will be prompted to confirm the changes before they're applied. Respond with
`yes`.

### Step 5.2.2: Clean-up and remove AWS configuration

Clean up after yourself by destroying the infrastructure created in this lab.

Comment out (or completely remove) only the aws_instance resource block from your `aws.tf` file:

```hcl
# resource "aws_instance" "web" {
# ...
# }
```
Run a `terraform apply` to destroy the EC2 instance no longer in configuration

```hcl
terraform apply
```
```text
...
An execution plan has been generated and is shown below.
Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.web will be destroyed
  - resource "aws_instance" "web" {
```

Answer `yes` to confirm the apply.

```text
aws_instance.web: Destroying... [id=i-0dc43d125b75a2bf2]
aws_instance.web: Still destroying... [id=i-0dc43d125b75a2bf2, 10s elapsed]
aws_instance.web: Still destroying... [id=i-0dc43d125b75a2bf2, 20s elapsed]
aws_instance.web: Still destroying... [id=i-0dc43d125b75a2bf2, 30s elapsed]
aws_instance.web: Destruction complete after 31s
```

After the EC2 instance has been terminated, rename the `aws.tf` back to `aws.tf.example`.
