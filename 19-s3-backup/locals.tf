resource "random_id" "bucket_suffix" {
  byte_length = 3
}

locals {
  bucket_name = "${var.project_name}-${data.aws_caller_identity.current.account_id}-${var.aws_region}-${random_id.bucket_suffix.hex}"
}
