variable "aws_region" {
  description = "AWS region to deploy into."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix and Project tag."
  type        = string
  default     = "p21-dashboard"
}

variable "instance_type" {
  description = "Instance type of the monitored server."
  type        = string
  default     = "t3.micro"
}

variable "metric_period" {
  description = "Dashboard metric period in seconds."
  type        = number
  default     = 60
}
