variable "aws_region" {
  description = "AWS Region where Project 19 will be deployed."
  type        = string
}

variable "project_name" {
  description = "Prefix used for resource names and tags."
  type        = string
  default     = "jeet-project19"

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.project_name))
    error_message = "project_name must contain only lowercase letters, numbers, and hyphens."
  }
}

variable "vpc_id" {
  description = "Existing VPC ID discovered with AWS CLI."
  type        = string

  validation {
    condition     = can(regex("^vpc-[0-9a-f]+$", var.vpc_id))
    error_message = "vpc_id must look like vpc-xxxxxxxx."
  }
}

variable "subnet_id" {
  description = "Existing public subnet ID with an active Internet Gateway route."
  type        = string

  validation {
    condition     = can(regex("^subnet-[0-9a-f]+$", var.subnet_id))
    error_message = "subnet_id must look like subnet-xxxxxxxx."
  }
}

variable "instance_type" {
  description = "EC2 instance type for the backup node."
  type        = string
  default     = "t3.micro"
}

variable "backup_schedule" {
  description = "Cron schedule. The default runs every 5 minutes for easy lab verification."
  type        = string
  default     = "*/5 * * * *"
}
