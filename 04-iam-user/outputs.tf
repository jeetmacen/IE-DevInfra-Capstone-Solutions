output "user_name" {
  description = "IAM user name."
  value       = aws_iam_user.reader.name
}

output "user_arn" {
  description = "IAM user ARN (used by the policy simulator)."
  value       = aws_iam_user.reader.arn
}

output "bucket_name" {
  description = "Test bucket name."
  value       = aws_s3_bucket.test.id
}

output "bucket_arn" {
  description = "Test bucket ARN."
  value       = aws_s3_bucket.test.arn
}

output "policy_json" {
  description = "Rendered IAM policy."
  value       = data.aws_iam_policy_document.s3_read.json
}
