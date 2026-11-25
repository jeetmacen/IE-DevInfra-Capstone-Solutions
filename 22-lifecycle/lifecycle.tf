resource "aws_s3_bucket_lifecycle_configuration" "logs" {
  bucket = aws_s3_bucket.logs.id

  rule {
    id     = "expire-logs-${var.expiration_days}d"
    status = "Enabled"

    filter {
      prefix = var.log_prefix
    }

    expiration {
      days = var.expiration_days
    }
  }
}
