variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix and Project tag."
  type        = string
  default     = "p01-web"
}

variable "vpc_cidr" {
  description = "CIDR block of the VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block of the public subnet."
  type        = string
  default     = "10.1.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type of the web server."
  type        = string
  default     = "t3.micro"
}
