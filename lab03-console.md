# Lab 3: Terraform Console

Duration: 10 minutes

Terraform configurations and commands often use [expressions](https://www.terraform.io/docs/configuration/expressions.html) like `google_compute_instance.web.machine_type` to reference Terraform resources and their attributes.

Terraform includes an interactive console for evaluating expressions against the current Terraform state. This is especially useful for checking values while editing configurations.

- Task 1: Use `terraform console` to query specific instance information.

## Task 1: Use `terraform console` to query specific instance information.

### Step 3.1.1

Find the machine_type of your instance

```shell
terraform console
```

```
> google_compute_instance.web.machine_type
f1-micro
```

Control+C exits the Terraform console

### Step 3.1.2

You can also pipe query information to the stdin of the console for evaluation

```shell
echo "google_compute_instance.web.machine_type" | terraform console
```

```
f1-micro
```
