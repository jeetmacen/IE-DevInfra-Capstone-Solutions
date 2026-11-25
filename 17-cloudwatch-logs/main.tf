# Read the pre-provided network. Terraform does not own or delete it.
data "aws_vpc" "existing" {
  id = var.existing_vpc_id
}

data "aws_subnet" "existing" {
  id = var.existing_subnet_id
}

data "aws_internet_gateway" "existing" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.existing_vpc_id]
  }
}

# Latest Amazon Linux 2023 x86_64 AMI.
data "aws_ami" "amazon_linux_2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "terraform_data" "network_validation" {
  lifecycle {
    precondition {
      condition     = data.aws_subnet.existing.vpc_id == data.aws_vpc.existing.id
      error_message = "The selected subnet does not belong to the selected VPC."
    }

    precondition {
      condition     = length(data.aws_internet_gateway.existing.attachments) > 0
      error_message = "The selected VPC does not have an attached Internet Gateway."
    }

    precondition {
      condition     = data.aws_subnet.existing.available_ip_address_count > 0
      error_message = "The selected subnet has no available IP addresses."
    }
  }
}

# No ingress rules: ports 22 and 3389, and all other inbound traffic, are blocked.
resource "aws_security_group" "ec2" {
  name_prefix = "${var.project_name}-"
  description = "Project 17 - no inbound connections; outbound HTTPS only"
  vpc_id      = data.aws_vpc.existing.id

  egress {
    description = "HTTPS for CloudWatch, SSM, and package repositories"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-ec2-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_cloudwatch_log_group" "boot" {
  name              = var.log_group_name
  retention_in_days = 7

  tags = {
    Name = "${var.project_name}-boot-logs"
  }
}

resource "aws_iam_role" "ec2" {
  name = "${var.project_name}-ec2-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Name = "${var.project_name}-ec2-role"
  }
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2.name
}

locals {
  cloudwatch_agent_config = templatefile(
    "${path.module}/cloudwatch-agent-config.json.tftpl",
    { log_group_name = aws_cloudwatch_log_group.boot.name }
  )
}

resource "aws_instance" "p17" {
  ami                         = data.aws_ami.amazon_linux_2023.id
  instance_type               = var.instance_type
  subnet_id                   = data.aws_subnet.existing.id
  vpc_security_group_ids      = [aws_security_group.ec2.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  associate_public_ip_address = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  user_data = templatefile(
    "${path.module}/user-data.sh.tftpl",
    { cloudwatch_agent_config = local.cloudwatch_agent_config }
  )

  user_data_replace_on_change = true

  root_block_device {
    volume_type           = "gp3"
    volume_size           = 8
    encrypted             = true
    delete_on_termination = true
  }

  depends_on = [
    terraform_data.network_validation,
    aws_iam_role_policy_attachment.ssm,
    aws_iam_role_policy_attachment.cloudwatch_agent,
    aws_cloudwatch_log_group.boot
  ]

  tags = {
    Name = "${var.project_name}-instance"
  }
}
