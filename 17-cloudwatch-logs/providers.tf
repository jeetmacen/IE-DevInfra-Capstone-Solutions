terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project   = "Project-17-CloudWatch-Log-Forwarding"
      ManagedBy = "Terraform"
      Owner     = "Jeet"
    }
  }
}
