variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "project_name" {
  type    = string
  default = "jeet-p16"
}

variable "owner" {
  type    = string
  default = "Jeet"
}

variable "vpc_cidr" {
  type    = string
  default = "10.16.0.0/16"
}

variable "public_subnet_a_cidr" {
  type    = string
  default = "10.16.11.0/24"
}

variable "public_subnet_b_cidr" {
  type    = string
  default = "10.16.12.0/24"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "allowed_https_cidr" {
  description = "CIDR allowed to access HTTPS"
  type        = string
  default     = "0.0.0.0/0"
}
