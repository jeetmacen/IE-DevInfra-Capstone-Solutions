data "aws_iam_policy_document" "s3_read" {
  statement {
    sid       = "BucketRead"
    actions   = var.read_actions.bucket
    resources = [aws_s3_bucket.test.arn]
  }

  statement {
    sid       = "ObjectRead"
    actions   = var.read_actions.object
    resources = ["${aws_s3_bucket.test.arn}/*"]
  }
}

resource "aws_iam_user" "reader" {
  name = coalesce(var.user_name, "${var.project_name}-${aws_s3_bucket.test.id}")
}

resource "aws_iam_policy" "s3_read" {
  name_prefix = "${var.project_name}-s3-read-"
  description = "Read-only access to the lab bucket"
  policy      = data.aws_iam_policy_document.s3_read.json
}

resource "aws_iam_user_policy_attachment" "s3_read" {
  user       = aws_iam_user.reader.name
  policy_arn = aws_iam_policy.s3_read.arn
}
