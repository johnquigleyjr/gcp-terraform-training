# Lab 10: Destroy

Duration: 5 minutes

You've now learned about all of the key features of Terraform, and how to use it
to manage your infrastructure. The last command we'll use is `terraform
destroy`. As you might guess from the name, this will destroy all of the
infrastructure managed by this configuration.

- Task 1: Destroy your infrastructure

## Task 1: Destroy your infrastructure

### Step 10.1.1

Run the command `terraform destroy`:

```shell
terraform destroy
```

```text
# ...
  # module.server.google_compute_firewall.gcp-externalssh will be destroyed
  - resource "google_compute_firewall" "gcp-externalssh" {
      - creation_timestamp      = "2020-09-09T09:09:14.424-07:00" -> null
      - destination_ranges      = [] -> null
      - direction               = "INGRESS" -> null
      - disabled                = false -> null
      - id                      = "projects/blissful-answer-288318/global/firewalls/gcp-externalssh" -> null
      - name                    = "gcp-externalssh" -> null
      - network                 = "https://www.googleapis.com/compute/v1/projects/blissful-answer-288318/global/networks/terraform-network" -> null
      - priority                = 1000 -> null
      - project                 = "blissful-answer-288318" -> null
      - self_link               = "https://www.googleapis.com/compute/v1/projects/blissful-answer-288318/global/firewalls/gcp-externalssh" -> null
      - source_ranges           = [
          - "0.0.0.0/0",
        ] -> null
      - source_service_accounts = [] -> null
      - source_tags             = [] -> null
      - target_service_accounts = [] -> null
      - target_tags             = [] -> null

      - allow {
          - ports    = [
              - "22",
            ] -> null
          - protocol = "tcp" -> null
        }
    }

  # module.server.google_compute_instance.web[0] will be destroyed
  - resource "google_compute_instance" "web" {
      - can_ip_forward       = false -> null
      - cpu_platform         = "Intel Haswell" -> null
      - current_status       = "RUNNING" -> null
      - deletion_protection  = false -> null
      - enable_display       = false -> null
      - guest_accelerator    = [] -> null
      - id                   = "projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web1" -> null
      - instance_id          = "5633949028022794535" -> null
      - label_fingerprint    = "42WmSpB8rSM=" -> null
      - labels               = {} -> null
      - machine_type         = "f1-micro" -> null
# ...
Plan: 0 to add, 0 to change, 6 to destroy.

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

module.server.local_file.pem: Destroying... [id=e7977c2af2236ff47699c5f221c9d58e8a607ba3]
module.server.local_file.pem: Destruction complete after 0s
module.server.google_compute_firewall.gcp-externalssh: Destroying... [id=projects/blissful-answer-288318/global/firewalls/gcp-externalssh]
module.server.google_compute_instance.web[0]: Destroying... [id=projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web1]
module.server.google_compute_instance.web[1]: Destroying... [id=projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web2]
module.server.google_compute_firewall.gcp-externalssh: Still destroying... [id=projects/blissful-answer-288318/global/firewalls/gcp-externalssh, 10s elapsed]
module.server.google_compute_instance.web[0]: Still destroying... [id=projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web1, 10s elapsed]
module.server.google_compute_instance.web[1]: Still destroying... [id=projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web2, 10s elapsed]
module.server.google_compute_firewall.gcp-externalssh: Destruction complete after 12s
module.server.google_compute_instance.web[1]: Still destroying... [id=projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web2, 20s elapsed]
module.server.google_compute_instance.web[0]: Still destroying... [id=projects/blissful-answer-288318/zones/us-east1-b/instances/frp-web1, 20s elapsed]
module.server.google_compute_instance.web[1]: Destruction complete after 23s
module.server.google_compute_instance.web[0]: Destruction complete after 23s
module.server.google_compute_network.vpc_network: Destroying... [id=projects/blissful-answer-288318/global/networks/terraform-network]
module.server.tls_private_key.ssh-key: Destroying... [id=01d53e0f92e1eb36c7f42314223a9d8107f007d7]
module.server.tls_private_key.ssh-key: Destruction complete after 0s
module.server.google_compute_network.vpc_network: Still destroying... [id=projects/blissful-answer-288318/global/networks/terraform-network, 10s elapsed]
module.server.google_compute_network.vpc_network: Still destroying... [id=projects/blissful-answer-288318/global/networks/terraform-network, 20s elapsed]
module.server.google_compute_network.vpc_network: Still destroying... [id=projects/blissful-answer-288318/global/networks/terraform-network, 30s elapsed]
module.server.google_compute_network.vpc_network: Still destroying... [id=projects/blissful-answer-288318/global/networks/terraform-network, 40s elapsed]
module.server.google_compute_network.vpc_network: Destruction complete after 44s

Destroy complete! Resources: 6 destroyed.
```

You'll need to confirm the action by responding with `yes`. You could achieve
the same effect by removing all of your configuration and running `terraform
apply`, but you often will want to keep the configuration, but not the
infrastructure created by the configuration.
