variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix and Project tag."
  type        = string
  default     = "p03-cpu"
}

variable "alert_email" {
  description = "Email address that receives ALARM and OK notifications."
  type        = string

  validation {
    condition     = can(regex("^[^@\\s]+@[^@\\s]+\\.[^@\\s]+$", var.alert_email))
    error_message = "alert_email must be a valid email address."
  }
}

variable "instance_type" {
  description = "EC2 instance type to monitor."
  type        = string
  default     = "t3.micro"
}

variable "cpu_threshold" {
  description = "Average CPU percentage that triggers the alarm."
  type        = number
  default     = 50
}

variable "evaluation_periods" {
  description = "Number of consecutive 60-second periods above the threshold."
  type        = number
  default     = 2
}
