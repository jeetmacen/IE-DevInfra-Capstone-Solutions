data "aws_vpc" "default" {
  default = true
}

data "aws_availability_zones" "available" {
  state = "available"

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }
}

data "aws_ec2_instance_type_offerings" "backend" {
  location_type = "availability-zone"

  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }
}

locals {
  supported_azs = setintersection(data.aws_availability_zones.available.names, data.aws_ec2_instance_type_offerings.backend.locations)
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "availability-zone"
    values = local.supported_azs
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "map-public-ip-on-launch"
    values = ["true"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  lifecycle {
    precondition {
      condition     = length(local.supported_azs) >= 2
      error_message = "Project 20 needs two standard Availability Zones offering ${var.instance_type} in ${var.aws_region}. Choose another instance type or region."
    }

    postcondition {
      condition     = length(self.ids) >= 2
      error_message = "Project 20 needs two available default subnets with public IPv4 assignment in separate zones that offer ${var.instance_type}. Choose an instance type or region with two suitable default subnets."
    }
  }
}

locals {
  # AWS has at most one default subnet per AZ.
  subnet_ids = slice(sort(data.aws_subnets.default.ids), 0, 2)
}
