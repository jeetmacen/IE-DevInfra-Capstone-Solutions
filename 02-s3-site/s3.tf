locals {
  site_path = "${path.module}/${var.site_dir}"
}

resource "aws_s3_bucket" "site" {
  bucket_prefix = "${var.project_name}-"
  force_destroy = true
}

resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.site.id
  key          = "index.html"
  source       = "${local.site_path}/index.html"
  etag         = filemd5("${local.site_path}/index.html")
  content_type = "text/html"
}
