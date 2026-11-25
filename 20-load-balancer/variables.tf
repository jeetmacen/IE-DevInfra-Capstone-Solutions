variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix and Project tag."
  type        = string
  default     = "p20-alb"
}

variable "instance_type" {
  description = "Instance type of the backend servers."
  type        = string
  default     = "t3.micro"
}

variable "instance_count" {
  description = "Number of backend servers, spread across the two subnets."
  type        = number
  default     = 2

  validation {
    condition     = var.instance_count >= 2 && var.instance_count <= 4
    error_message = "Use between 2 and 4 instances."
  }
}
