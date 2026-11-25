variable "aws_region" {
  description = "AWS region containing the default VPC"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project resource name prefix"
  type        = string
  default     = "project23-iam-role"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "allowed_s3_bucket_arns" {
  description = "Specific S3 bucket ARNs. Leave empty for read access to all buckets in this lab."
  type        = list(string)
  default     = []
}
