# One object inside the rule's prefix and one control object outside it.
resource "aws_s3_object" "sample" {
  for_each = toset(["${var.log_prefix}sample.log", "control/sample.log"])

  bucket       = aws_s3_bucket.logs.id
  key          = each.value
  source       = "${path.module}/sample-logs/sample.log"
  etag         = filemd5("${path.module}/sample-logs/sample.log")
  content_type = "text/plain"

  depends_on = [aws_s3_bucket_lifecycle_configuration.logs]
}
