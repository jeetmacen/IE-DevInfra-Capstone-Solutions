data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "monitored" {
  ami                         = data.aws_ssm_parameter.al2023.insecure_value
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.isolated.id]
  monitoring                  = true
  user_data                   = replace(file("${path.module}/scripts/cpu-load.sh"), "\r\n", "\n")
  user_data_replace_on_change = true

  # Standard credits: the load test cannot bill surplus burst credits.
  credit_specification {
    cpu_credits = "standard"
  }

  metadata_options {
    http_tokens = "required"
  }

  root_block_device {
    encrypted = true
  }

  tags = {
    Name = var.project_name
  }
}
