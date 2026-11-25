```shell
PS C:\Users\jeet.majumdar\Code\capstone> cd .\capstone-solutions\01-ec2-web\
PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> cp terraform.tfvars.example terraform.tfvars
PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> terraform init
Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 5.0"...
- Installing hashicorp/aws v5.100.0...
- Installed hashicorp/aws v5.100.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> terraform fmt -check
PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> terraform validate
Success! The configuration is valid.

PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> terraform plan -out=tfplan
data.aws_availability_zones.available: Reading...
data.aws_ssm_parameter.al2023: Reading...
data.aws_ssm_parameter.al2023: Read complete after 1s [id=/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64]
data.aws_availability_zones.available: Read complete after 1s [id=us-east-1]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # aws_instance.web will be created
  + resource "aws_instance" "web" {
      + ami                                  = "ami-06f98347e4f9c7328"
      + arn                                  = (known after apply)
      + associate_public_ip_address          = true
      + availability_zone                    = (known after apply)
      + cpu_core_count                       = (known after apply)
      + cpu_threads_per_core                 = (known after apply)
      + disable_api_stop                     = (known after apply)
      + disable_api_termination              = (known after apply)
      + ebs_optimized                        = (known after apply)
      + enable_primary_ipv6                  = (known after apply)
      + get_password_data                    = false
      + host_id                              = (known after apply)
      + host_resource_group_arn              = (known after apply)
      + iam_instance_profile                 = (known after apply)
      + id                                   = (known after apply)
      + instance_initiated_shutdown_behavior = (known after apply)
      + instance_lifecycle                   = (known after apply)
      + instance_state                       = (known after apply)
      + instance_type                        = "t3.micro"
      + ipv6_address_count                   = (known after apply)
      + ipv6_addresses                       = (known after apply)
      + key_name                             = (known after apply)
      + monitoring                           = (known after apply)
      + outpost_arn                          = (known after apply)
      + password_data                        = (known after apply)
      + placement_group                      = (known after apply)
      + placement_partition_number           = (known after apply)
      + primary_network_interface_id         = (known after apply)
      + private_dns                          = (known after apply)
      + private_ip                           = (known after apply)
      + public_dns                           = (known after apply)
      + public_ip                            = (known after apply)
      + secondary_private_ips                = (known after apply)
      + security_groups                      = (known after apply)
      + source_dest_check                    = true
      + spot_instance_request_id             = (known after apply)
      + subnet_id                            = (known after apply)
      + tags                                 = {
          + "Name" = "p01-web"
        }
      + tags_all                             = {
          + "ManagedBy" = "Terraform"
          + "Name"      = "p01-web"
          + "Project"   = "p01-web"
        }
      + tenancy                              = (known after apply)
      + user_data                            = "f5d54159fe26d1a7f513ba3ca09d56ac99f4e9d7"
      + user_data_base64                     = (known after apply)
      + user_data_replace_on_change          = true
      + vpc_security_group_ids               = (known after apply)

      + capacity_reservation_specification (known after apply)

      + cpu_options (known after apply)

      + ebs_block_device (known after apply)

      + enclave_options (known after apply)

      + ephemeral_block_device (known after apply)

      + instance_market_options (known after apply)

      + maintenance_options (known after apply)

      + metadata_options {
          + http_endpoint               = "enabled"
          + http_protocol_ipv6          = "disabled"
          + http_put_response_hop_limit = (known after apply)
          + http_tokens                 = "required"
          + instance_metadata_tags      = (known after apply)
        }

      + network_interface (known after apply)

      + private_dns_name_options (known after apply)

      + root_block_device {
          + delete_on_termination = true
          + device_name           = (known after apply)
          + encrypted             = true
          + iops                  = (known after apply)
          + kms_key_id            = (known after apply)
          + tags_all              = (known after apply)
          + throughput            = (known after apply)
          + volume_id             = (known after apply)
          + volume_size           = (known after apply)
          + volume_type           = (known after apply)
        }
    }

  # aws_internet_gateway.main will be created
  + resource "aws_internet_gateway" "main" {
      + arn      = (known after apply)
      + id       = (known after apply)
      + owner_id = (known after apply)
      + tags     = {
          + "Name" = "p01-web"
        }
      + tags_all = {
          + "ManagedBy" = "Terraform"
          + "Name"      = "p01-web"
          + "Project"   = "p01-web"
        }
      + vpc_id   = (known after apply)
    }

  # aws_route_table.public will be created
  + resource "aws_route_table" "public" {
      + arn              = (known after apply)
      + id               = (known after apply)
      + owner_id         = (known after apply)
      + propagating_vgws = (known after apply)
      + route            = [
          + {
              + cidr_block                 = "0.0.0.0/0"
              + gateway_id                 = (known after apply)
                # (11 unchanged attributes hidden)
            },
        ]
      + tags             = {
          + "Name" = "p01-web-public"
        }
      + tags_all         = {
          + "ManagedBy" = "Terraform"
          + "Name"      = "p01-web-public"
          + "Project"   = "p01-web"
        }
      + vpc_id           = (known after apply)
    }

  # aws_route_table_association.public will be created
  + resource "aws_route_table_association" "public" {
      + id             = (known after apply)
      + route_table_id = (known after apply)
      + subnet_id      = (known after apply)
    }

  # aws_security_group.web will be created
  + resource "aws_security_group" "web" {
      + arn                    = (known after apply)
      + description            = "HTTP from the internet; no SSH or RDP"
      + egress                 = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "Package downloads"
              + from_port        = 0
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "-1"
              + security_groups  = []
              + self             = false
              + to_port          = 0
            },
        ]
      + id                     = (known after apply)
      + ingress                = [
          + {
              + cidr_blocks      = [
                  + "0.0.0.0/0",
                ]
              + description      = "HTTP"
              + from_port        = 80
              + ipv6_cidr_blocks = []
              + prefix_list_ids  = []
              + protocol         = "tcp"
              + security_groups  = []
              + self             = false
              + to_port          = 80
            },
        ]
      + name                   = (known after apply)
      + name_prefix            = "p01-web-"
      + owner_id               = (known after apply)
      + revoke_rules_on_delete = false
      + tags_all               = {
          + "ManagedBy" = "Terraform"
          + "Project"   = "p01-web"
        }
      + vpc_id                 = (known after apply)
    }

  # aws_subnet.public will be created
  + resource "aws_subnet" "public" {
      + arn                                            = (known after apply)
      + assign_ipv6_address_on_creation                = false
      + availability_zone                              = "us-east-1a"
      + availability_zone_id                           = (known after apply)
      + cidr_block                                     = "10.1.1.0/24"
      + enable_dns64                                   = false
      + enable_resource_name_dns_a_record_on_launch    = false
      + enable_resource_name_dns_aaaa_record_on_launch = false
      + id                                             = (known after apply)
      + ipv6_cidr_block_association_id                 = (known after apply)
      + ipv6_native                                    = false
      + map_public_ip_on_launch                        = false
      + owner_id                                       = (known after apply)
      + private_dns_hostname_type_on_launch            = (known after apply)
      + tags                                           = {
          + "Name" = "p01-web-public"
        }
      + tags_all                                       = {
          + "ManagedBy" = "Terraform"
          + "Name"      = "p01-web-public"
          + "Project"   = "p01-web"
        }
      + vpc_id                                         = (known after apply)
    }

  # aws_vpc.main will be created
  + resource "aws_vpc" "main" {
      + arn                                  = (known after apply)
      + cidr_block                           = "10.1.0.0/16"
      + default_network_acl_id               = (known after apply)
      + default_route_table_id               = (known after apply)
      + default_security_group_id            = (known after apply)
      + dhcp_options_id                      = (known after apply)
      + enable_dns_hostnames                 = true
      + enable_dns_support                   = true
      + enable_network_address_usage_metrics = (known after apply)
      + id                                   = (known after apply)
      + instance_tenancy                     = "default"
      + ipv6_association_id                  = (known after apply)
      + ipv6_cidr_block                      = (known after apply)
      + ipv6_cidr_block_network_border_group = (known after apply)
      + main_route_table_id                  = (known after apply)
      + owner_id                             = (known after apply)
      + tags                                 = {
          + "Name" = "p01-web"
        }
      + tags_all                             = {
          + "ManagedBy" = "Terraform"
          + "Name"      = "p01-web"
          + "Project"   = "p01-web"
        }
    }

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + instance_id = (known after apply)
  + public_ip   = (known after apply)
  + url         = (known after apply)

────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────

Saved the plan to: tfplan

To perform exactly these actions, run the following command to apply:
    terraform apply "tfplan"
PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> terraform apply tfplan
aws_vpc.main: Creating...
aws_vpc.main: Still creating... [00m10s elapsed]
aws_vpc.main: Creation complete after 17s [id=vpc-05a580c3a5c9b2652]
aws_internet_gateway.main: Creating...
aws_subnet.public: Creating...
aws_security_group.web: Creating...
aws_subnet.public: Creation complete after 3s [id=subnet-0ae5dcc2da17f1673]
aws_internet_gateway.main: Creation complete after 3s [id=igw-08038b40b06acee12]
aws_route_table.public: Creating...
aws_route_table.public: Creation complete after 4s [id=rtb-00183cdf332ca49ef]
aws_route_table_association.public: Creating...
aws_security_group.web: Creation complete after 8s [id=sg-01b3cf2599e876e96]
aws_route_table_association.public: Creation complete after 1s [id=rtbassoc-0d0860657145f879c]
aws_instance.web: Creating...
aws_instance.web: Still creating... [00m10s elapsed]
aws_instance.web: Creation complete after 19s [id=i-0af27311049aa3c4d]

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

instance_id = "i-0af27311049aa3c4d"
public_ip = "3.238.7.89"
url = "http://3.238.7.89/"
PS C:\Users\jeet.majumdar\Code\capstone\capstone-solutions\01-ec2-web> terraform destroy
data.aws_availability_zones.available: Reading...
data.aws_ssm_parameter.al2023: Reading...
aws_vpc.main: Refreshing state... [id=vpc-05a580c3a5c9b2652]
data.aws_availability_zones.available: Read complete after 2s [id=us-east-1]
data.aws_ssm_parameter.al2023: Read complete after 2s [id=/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64]
aws_internet_gateway.main: Refreshing state... [id=igw-08038b40b06acee12]
aws_subnet.public: Refreshing state... [id=subnet-0ae5dcc2da17f1673]
aws_security_group.web: Refreshing state... [id=sg-01b3cf2599e876e96]
aws_route_table.public: Refreshing state... [id=rtb-00183cdf332ca49ef]
aws_route_table_association.public: Refreshing state... [id=rtbassoc-0d0860657145f879c]
aws_instance.web: Refreshing state... [id=i-0af27311049aa3c4d]

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  - destroy

Terraform will perform the following actions:

  # aws_instance.web will be destroyed
  - resource "aws_instance" "web" {
      - ami                                  = "ami-06f98347e4f9c7328" -> null
      - arn                                  = "arn:aws:ec2:us-east-1:590507089733:instance/i-0af27311049aa3c4d" -> null
      - associate_public_ip_address          = true -> null
      - availability_zone                    = "us-east-1a" -> null
      - cpu_core_count                       = 1 -> null
      - cpu_threads_per_core                 = 2 -> null
      - disable_api_stop                     = false -> null
      - disable_api_termination              = false -> null
      - ebs_optimized                        = false -> null
      - get_password_data                    = false -> null
      - hibernation                          = false -> null
      - id                                   = "i-0af27311049aa3c4d" -> null
      - instance_initiated_shutdown_behavior = "stop" -> null
      - instance_state                       = "running" -> null
      - instance_type                        = "t3.micro" -> null
      - ipv6_address_count                   = 0 -> null
      - ipv6_addresses                       = [] -> null
      - monitoring                           = false -> null
      - placement_partition_number           = 0 -> null
      - primary_network_interface_id         = "eni-0d2df7271b1bd65fb" -> null
      - private_dns                          = "ip-10-1-1-122.ec2.internal" -> null
      - private_ip                           = "10.1.1.122" -> null
      - public_dns                           = "ec2-3-238-7-89.compute-1.amazonaws.com" -> null
      - public_ip                            = "3.238.7.89" -> null
      - secondary_private_ips                = [] -> null
      - security_groups                      = [] -> null
      - source_dest_check                    = true -> null
      - subnet_id                            = "subnet-0ae5dcc2da17f1673" -> null
      - tags                                 = {
          - "Name" = "p01-web"
        } -> null
      - tags_all                             = {
          - "ManagedBy" = "Terraform"
          - "Name"      = "p01-web"
          - "Project"   = "p01-web"
        } -> null
      - tenancy                              = "default" -> null
      - user_data                            = "f5d54159fe26d1a7f513ba3ca09d56ac99f4e9d7" -> null
      - user_data_replace_on_change          = true -> null
      - vpc_security_group_ids               = [
          - "sg-01b3cf2599e876e96",
        ] -> null
        # (8 unchanged attributes hidden)

      - capacity_reservation_specification {
          - capacity_reservation_preference = "open" -> null
        }

      - cpu_options {
          - core_count       = 1 -> null
          - threads_per_core = 2 -> null
            # (1 unchanged attribute hidden)
        }

      - credit_specification {
          - cpu_credits = "unlimited" -> null
        }

      - enclave_options {
          - enabled = false -> null
        }

      - maintenance_options {
          - auto_recovery = "default" -> null
        }

      - metadata_options {
          - http_endpoint               = "enabled" -> null
          - http_protocol_ipv6          = "disabled" -> null
          - http_put_response_hop_limit = 2 -> null
          - http_tokens                 = "required" -> null
          - instance_metadata_tags      = "disabled" -> null
        }

      - private_dns_name_options {
          - enable_resource_name_dns_a_record    = false -> null
          - enable_resource_name_dns_aaaa_record = false -> null
          - hostname_type                        = "ip-name" -> null
        }

      - root_block_device {
          - delete_on_termination = true -> null
          - device_name           = "/dev/xvda" -> null
          - encrypted             = true -> null
          - iops                  = 3000 -> null
          - kms_key_id            = "arn:aws:kms:us-east-1:590507089733:key/db6687ae-1d69-4917-9f1a-b7d6227995f7" -> null
          - tags                  = {} -> null
          - tags_all              = {
              - "ManagedBy" = "Terraform"
              - "Project"   = "p01-web"
            } -> null
          - throughput            = 125 -> null
          - volume_id             = "vol-079434c3f4491cd05" -> null
          - volume_size           = 8 -> null
          - volume_type           = "gp3" -> null
        }
    }

  # aws_internet_gateway.main will be destroyed
  - resource "aws_internet_gateway" "main" {
      - arn      = "arn:aws:ec2:us-east-1:590507089733:internet-gateway/igw-08038b40b06acee12" -> null
      - id       = "igw-08038b40b06acee12" -> null
      - owner_id = "590507089733" -> null
      - tags     = {
          - "Name" = "p01-web"
        } -> null
      - tags_all = {
          - "ManagedBy" = "Terraform"
          - "Name"      = "p01-web"
          - "Project"   = "p01-web"
        } -> null
      - vpc_id   = "vpc-05a580c3a5c9b2652" -> null
    }

  # aws_route_table.public will be destroyed
  - resource "aws_route_table" "public" {
      - arn              = "arn:aws:ec2:us-east-1:590507089733:route-table/rtb-00183cdf332ca49ef" -> null
      - id               = "rtb-00183cdf332ca49ef" -> null
      - owner_id         = "590507089733" -> null
      - propagating_vgws = [] -> null
      - route            = [
          - {
              - cidr_block                 = "0.0.0.0/0"
              - gateway_id                 = "igw-08038b40b06acee12"
                # (11 unchanged attributes hidden)
            },
        ] -> null
      - tags             = {
          - "Name" = "p01-web-public"
        } -> null
      - tags_all         = {
          - "ManagedBy" = "Terraform"
          - "Name"      = "p01-web-public"
          - "Project"   = "p01-web"
        } -> null
      - vpc_id           = "vpc-05a580c3a5c9b2652" -> null
    }

  # aws_route_table_association.public will be destroyed
  - resource "aws_route_table_association" "public" {
      - id             = "rtbassoc-0d0860657145f879c" -> null
      - route_table_id = "rtb-00183cdf332ca49ef" -> null
      - subnet_id      = "subnet-0ae5dcc2da17f1673" -> null
        # (1 unchanged attribute hidden)
    }

  # aws_security_group.web will be destroyed
  - resource "aws_security_group" "web" {
      - arn                    = "arn:aws:ec2:us-east-1:590507089733:security-group/sg-01b3cf2599e876e96" -> null
      - description            = "HTTP from the internet; no SSH or RDP" -> null
      - egress                 = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "Package downloads"
              - from_port        = 0
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "-1"
              - security_groups  = []
              - self             = false
              - to_port          = 0
            },
        ] -> null
      - id                     = "sg-01b3cf2599e876e96" -> null
      - ingress                = [
          - {
              - cidr_blocks      = [
                  - "0.0.0.0/0",
                ]
              - description      = "HTTP"
              - from_port        = 80
              - ipv6_cidr_blocks = []
              - prefix_list_ids  = []
              - protocol         = "tcp"
              - security_groups  = []
              - self             = false
              - to_port          = 80
            },
        ] -> null
      - name                   = "p01-web-20261119122254464300000001" -> null
      - name_prefix            = "p01-web-" -> null
      - owner_id               = "590507089733" -> null
      - revoke_rules_on_delete = false -> null
      - tags                   = {} -> null
      - tags_all               = {
          - "ManagedBy" = "Terraform"
          - "Project"   = "p01-web"
        } -> null
      - vpc_id                 = "vpc-05a580c3a5c9b2652" -> null
    }

  # aws_subnet.public will be destroyed
  - resource "aws_subnet" "public" {
      - arn                                            = "arn:aws:ec2:us-east-1:590507089733:subnet/subnet-0ae5dcc2da17f1673" -> null
      - assign_ipv6_address_on_creation                = false -> null
      - availability_zone                              = "us-east-1a" -> null
      - availability_zone_id                           = "use1-az1" -> null
      - cidr_block                                     = "10.1.1.0/24" -> null
      - enable_dns64                                   = false -> null
      - enable_lni_at_device_index                     = 0 -> null
      - enable_resource_name_dns_a_record_on_launch    = false -> null
      - enable_resource_name_dns_aaaa_record_on_launch = false -> null
      - id                                             = "subnet-0ae5dcc2da17f1673" -> null
      - ipv6_native                                    = false -> null
      - map_customer_owned_ip_on_launch                = false -> null
      - map_public_ip_on_launch                        = false -> null
      - owner_id                                       = "590507089733" -> null
      - private_dns_hostname_type_on_launch            = "ip-name" -> null
      - tags                                           = {
          - "Name" = "p01-web-public"
        } -> null
      - tags_all                                       = {
          - "ManagedBy" = "Terraform"
          - "Name"      = "p01-web-public"
          - "Project"   = "p01-web"
        } -> null
      - vpc_id                                         = "vpc-05a580c3a5c9b2652" -> null
        # (4 unchanged attributes hidden)
    }

  # aws_vpc.main will be destroyed
  - resource "aws_vpc" "main" {
      - arn                                  = "arn:aws:ec2:us-east-1:590507089733:vpc/vpc-05a580c3a5c9b2652" -> null
      - assign_generated_ipv6_cidr_block     = false -> null
      - cidr_block                           = "10.1.0.0/16" -> null
      - default_network_acl_id               = "acl-0cb07321e3e26d4b4" -> null
      - default_route_table_id               = "rtb-0c241fbc8cfeb2ddf" -> null
      - default_security_group_id            = "sg-0beb6ec6f594cad36" -> null
      - dhcp_options_id                      = "dopt-efbc1194" -> null
      - enable_dns_hostnames                 = true -> null
      - enable_dns_support                   = true -> null
      - enable_network_address_usage_metrics = false -> null
      - id                                   = "vpc-05a580c3a5c9b2652" -> null
      - instance_tenancy                     = "default" -> null
      - ipv6_netmask_length                  = 0 -> null
      - main_route_table_id                  = "rtb-0c241fbc8cfeb2ddf" -> null
      - owner_id                             = "590507089733" -> null
      - tags                                 = {
          - "Name" = "p01-web"
        } -> null
      - tags_all                             = {
          - "ManagedBy" = "Terraform"
          - "Name"      = "p01-web"
          - "Project"   = "p01-web"
        } -> null
        # (4 unchanged attributes hidden)
    }

Plan: 0 to add, 0 to change, 7 to destroy.

Changes to Outputs:
  - instance_id = "i-0af27311049aa3c4d" -> null
  - public_ip   = "3.238.7.89" -> null
  - url         = "http://3.238.7.89/" -> null

Do you really want to destroy all resources?
  Terraform will destroy all your managed infrastructure, as shown above.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

aws_instance.web: Destroying... [id=i-0af27311049aa3c4d]
aws_instance.web: Still destroying... [id=i-0af27311049aa3c4d, 00m10s elapsed]
aws_instance.web: Still destroying... [id=i-0af27311049aa3c4d, 00m20s elapsed]
aws_instance.web: Still destroying... [id=i-0af27311049aa3c4d, 00m30s elapsed]
aws_instance.web: Destruction complete after 33s
aws_route_table_association.public: Destroying... [id=rtbassoc-0d0860657145f879c]
aws_security_group.web: Destroying... [id=sg-01b3cf2599e876e96]
aws_route_table_association.public: Destruction complete after 3s
aws_route_table.public: Destroying... [id=rtb-00183cdf332ca49ef]
aws_subnet.public: Destroying... [id=subnet-0ae5dcc2da17f1673]
aws_security_group.web: Destruction complete after 5s
aws_subnet.public: Destruction complete after 2s
aws_route_table.public: Destruction complete after 3s
aws_internet_gateway.main: Destroying... [id=igw-08038b40b06acee12]
aws_internet_gateway.main: Destruction complete after 1s
aws_vpc.main: Destroying... [id=vpc-05a580c3a5c9b2652]
aws_vpc.main: Destruction complete after 2s

Destroy complete! Resources: 7 destroyed.
```