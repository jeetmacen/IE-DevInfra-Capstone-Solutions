variable "aws_region" {
  description = "AWS Region containing the pre-provided VPC"
  type        = string
}

variable "project_name" {
  description = "Project 17 resource-name prefix"
  type        = string
  default     = "p17-cloudwatch"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "log_group_name" {
  description = "Dedicated CloudWatch Logs group"
  type        = string
  default     = "/p17/ec2/boot"
}

variable "existing_vpc_id" {
  description = "ID of the pre-provided VPC"
  type        = string
}

variable "existing_subnet_id" {
  description = "ID of an existing public subnet in the pre-provided VPC"
  type        = string
}
