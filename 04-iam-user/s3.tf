resource "aws_s3_bucket" "test" {
  bucket_prefix = "${var.project_name}-read-"
  force_destroy = true
}

resource "aws_s3_bucket_public_access_block" "test" {
  bucket                  = aws_s3_bucket.test.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_object" "sample" {
  bucket  = aws_s3_bucket.test.id
  key     = "sample.txt"
  content = "Read-only example"
}
