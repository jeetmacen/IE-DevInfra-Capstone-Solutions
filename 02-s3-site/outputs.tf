output "bucket_name" {
  description = "Name of the website bucket."
  value       = aws_s3_bucket.site.id
}

output "url" {
  description = "S3 website endpoint (HTTP)."
  value       = "http://${aws_s3_bucket_website_configuration.site.website_endpoint}/"
}
