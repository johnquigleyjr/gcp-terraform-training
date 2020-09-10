# Lab 2: Outputs

Duration: 10 minutes

Outputs allow us to query for specific values rather than parse metadata in `terraform show`.

- Task 1: Create output variables in your configuration file
- Task 2: Use the output command to find specific variables

## Task 1: Create output variables in your configuration file

### Step 2.1.1

Create a new output variable named "public_ip" to output the instance's public_ip attributes

```hcl
output "public_ip" {
  value = google_compute_instance.web.network_interface[0].access_config[0].nat_ip
}

```

### Step 2.1.2

Run the refresh command to pick up the new output

```shell
terraform refresh
```

## Task 2: Use the output command to find specific variables

### Step 2.2.1 Try the terraform output command with no specifications

```shell
terraform output
```

### Step 2.2.2 Query specifically for the public_ip attributes

```shell
terraform output public_ip
```

### Step 2.2.3 Wrap an output query to ping the IP address

```shell
ping $(terraform output public_ip)
```
