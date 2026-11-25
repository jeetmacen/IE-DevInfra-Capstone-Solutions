data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "monitored" {
  ami                         = data.aws_ssm_parameter.al2023.value
  instance_type               = var.instance_type
  subnet_id                   = sort(data.aws_subnets.default.ids)[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.isolated.id]
  monitoring                  = true

  # Short CPU burst after boot so the dashboard has visible data.
  user_data = <<-EOT
    #!/bin/bash
    timeout 90 yes > /dev/null
  EOT

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = var.project_name
  }
}
