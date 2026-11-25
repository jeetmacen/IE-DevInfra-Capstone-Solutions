data "aws_vpc" "default" {
  default = true
}

data "aws_ec2_instance_type_offerings" "monitored" {
  location_type = "availability-zone"

  filter {
    name   = "instance-type"
    values = [var.instance_type]
  }

  lifecycle {
    postcondition {
      condition     = length(self.locations) > 0
      error_message = "${var.instance_type} is not offered in ${var.aws_region}."
    }
  }
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }

  filter {
    name   = "availability-zone"
    values = data.aws_ec2_instance_type_offerings.monitored.locations
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  lifecycle {
    postcondition {
      condition     = length(self.ids) > 0
      error_message = "The default VPC in ${var.aws_region} needs an available default subnet in a zone offering ${var.instance_type}."
    }
  }
}
