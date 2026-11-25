data "aws_caller_identity" "current" {}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

data "aws_ssm_parameter" "amazon_linux_2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    sid     = "AllowEC2AssumeRole"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.project_name}-ec2-role"
  description        = "IAM role for Project 23 EC2 S3 access"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

locals {
  use_specific_buckets = length(var.allowed_s3_bucket_arns) > 0
  bucket_arns = local.use_specific_buckets ? var.allowed_s3_bucket_arns : [
    "arn:aws:s3:::*"
  ]
  object_arns = local.use_specific_buckets ? [
    for bucket_arn in var.allowed_s3_bucket_arns : "${bucket_arn}/*"
    ] : [
    "arn:aws:s3:::*/*"
  ]
}

data "aws_iam_policy_document" "s3_read" {
  statement {
    sid       = "ListBuckets"
    effect    = "Allow"
    actions   = ["s3:ListAllMyBuckets"]
    resources = ["*"]
  }

  statement {
    sid    = "ReadBuckets"
    effect = "Allow"
    actions = [
      "s3:GetBucketLocation",
      "s3:ListBucket"
    ]
    resources = local.bucket_arns
  }

  statement {
    sid       = "ReadObjects"
    effect    = "Allow"
    actions   = ["s3:GetObject"]
    resources = local.object_arns
  }
}

resource "aws_iam_policy" "s3_read" {
  name        = "${var.project_name}-s3-read"
  description = "Read-only S3 access for Project 23"
  policy      = data.aws_iam_policy_document.s3_read.json
}

resource "aws_iam_role_policy_attachment" "s3_read" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.s3_read.arn
}

resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_role.name
}

resource "aws_security_group" "ec2" {
  name        = "${var.project_name}-no-inbound"
  description = "No inbound access; managed through AWS Systems Manager"
  vpc_id      = data.aws_vpc.default.id

  # Intentionally no ingress rules: ports 22 and 3389 remain closed.
  egress {
    description = "Allow outbound traffic for SSM and AWS APIs"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-no-inbound"
  }
}

resource "aws_instance" "project23" {
  ami           = data.aws_ssm_parameter.amazon_linux_2023.value
  instance_type = var.instance_type

  subnet_id              = sort(data.aws_subnets.default.ids)[0]
  vpc_security_group_ids = [aws_security_group.ec2.id]

  iam_instance_profile        = aws_iam_instance_profile.ec2_profile.name
  associate_public_ip_address = true

  # No key_name: SSH is not used.
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true

    tags = {
      Name = "${var.project_name}-root-volume"
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.s3_read,
    aws_iam_role_policy_attachment.ssm_core
  ]

  tags = {
    Name = var.project_name
  }
}
