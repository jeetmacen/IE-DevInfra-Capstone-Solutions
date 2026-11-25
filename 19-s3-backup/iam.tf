data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "backup" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.backup.name
  policy_arn = "arn:${data.aws_partition.current.partition}:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

data "aws_iam_policy_document" "s3_backup" {
  statement {
    sid       = "ReadBucketMetadata"
    effect    = "Allow"
    actions   = ["s3:GetBucketLocation", "s3:ListBucket"]
    resources = [aws_s3_bucket.backups.arn]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["backups", "backups/*"]
    }
  }

  statement {
    sid       = "WriteBackupsOnly"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.backups.arn}/backups/*"]
  }
}

resource "aws_iam_role_policy" "s3_backup" {
  name   = "${var.project_name}-s3-backup"
  role   = aws_iam_role.backup.id
  policy = data.aws_iam_policy_document.s3_backup.json
}

resource "aws_iam_instance_profile" "backup" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.backup.name
}
