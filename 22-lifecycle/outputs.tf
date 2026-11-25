output "bucket_name" {
  description = "Log bucket name."
  value       = aws_s3_bucket.logs.bucket
}

output "rule_id" {
  description = "Lifecycle rule ID."
  value       = "expire-logs-${var.expiration_days}d"
}

output "log_key" {
  description = "Sample object covered by the rule."
  value       = "${var.log_prefix}sample.log"
}
