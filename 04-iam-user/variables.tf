variable "aws_region" {
  description = "AWS region for the test bucket."
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Name prefix and Project tag."
  type        = string
  default     = "p04"
}

variable "user_name" {
  description = "Name of the IAM user (null = generated from the bucket name)."
  type        = string
  default     = null
}

# The policy is driven entirely by this variable.
variable "read_actions" {
  description = "S3 read actions granted on the bucket and on its objects."
  type = object({
    bucket = set(string)
    object = set(string)
  })
  default = {
    bucket = ["s3:ListBucket", "s3:GetBucketLocation"]
    object = ["s3:GetObject"]
  }

  validation {
    condition = (
      length(var.read_actions.bucket) > 0 &&
      length(var.read_actions.object) > 0 &&
      alltrue([for a in var.read_actions.bucket : contains(["s3:ListBucket", "s3:GetBucketLocation"], a)]) &&
      alltrue([for a in var.read_actions.object : a == "s3:GetObject"])
    )
    error_message = "Only s3:ListBucket/s3:GetBucketLocation (bucket) and s3:GetObject (objects) are allowed."
  }
}
