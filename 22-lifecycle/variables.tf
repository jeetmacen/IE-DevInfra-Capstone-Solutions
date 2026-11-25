variable "aws_region" {
  description = "AWS region for the bucket."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project tag."
  type        = string
  default     = "p22-lifecycle"
}

variable "log_prefix" {
  description = "Key prefix the expiration rule applies to."
  type        = string
  default     = "logs/"
}

variable "expiration_days" {
  description = "Days after creation when log objects are deleted."
  type        = number
  default     = 30

  validation {
    condition     = var.expiration_days >= 1
    error_message = "expiration_days must be at least 1."
  }
}
