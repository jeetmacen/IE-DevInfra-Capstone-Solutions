variable "aws_region" {
  description = "AWS region for the bucket."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Bucket name prefix and Project tag."
  type        = string
  default     = "p02-static"
}

variable "site_dir" {
  description = "Local folder with the website files (relative to this module)."
  type        = string
  default     = "site"
}
