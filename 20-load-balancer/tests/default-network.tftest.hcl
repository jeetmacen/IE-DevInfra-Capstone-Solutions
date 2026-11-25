mock_provider "aws" {
  mock_data "aws_availability_zones" {
    defaults = { names = ["us-east-1a", "us-east-1b", "us-east-1e"] }
  }

  mock_data "aws_ec2_instance_type_offerings" {
    defaults = { locations = ["us-east-1a", "us-east-1b"] }
  }

  mock_data "aws_vpc" {
    defaults = {
      id         = "vpc-00000000000000001"
      cidr_block = "172.31.0.0/16"
    }
  }

  mock_data "aws_ssm_parameter" {
    defaults = { value = "ami-00000000000000001" }
  }
}

run "spread_backends_across_alb_subnets" {
  command = plan

  override_data {
    target = data.aws_subnets.default
    values = { ids = ["subnet-00000000000000003", "subnet-00000000000000001", "subnet-00000000000000002"] }
  }

  assert {
    condition     = one([for f in data.aws_subnets.default.filter : toset(f.values) if f.name == "availability-zone"]) == toset(["us-east-1a", "us-east-1b"])
    error_message = "The subnet lookup must exclude us-east-1e when EC2 does not offer the requested instance type there."
  }

  assert {
    condition     = length(aws_lb.web.subnets) == 2 && toset(aws_instance.backend[*].subnet_id) == aws_lb.web.subnets
    error_message = "The two backends must occupy different subnets, both enabled on the ALB."
  }

}

run "reject_single_supported_zone" {
  command = plan

  override_data {
    target = data.aws_ec2_instance_type_offerings.backend
    values = { locations = ["us-east-1b"] }
  }

  expect_failures = [data.aws_subnets.default]
}

run "reject_single_subnet" {
  command = plan

  override_data {
    target = data.aws_subnets.default
    values = { ids = ["subnet-00000000000000001"] }
  }

  expect_failures = [data.aws_subnets.default]
}
