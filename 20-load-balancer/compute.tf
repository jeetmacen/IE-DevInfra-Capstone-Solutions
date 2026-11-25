data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "backend" {
  count = var.instance_count

  ami                    = data.aws_ssm_parameter.al2023.value
  instance_type          = var.instance_type
  subnet_id              = local.subnet_ids[count.index % length(local.subnet_ids)]
  vpc_security_group_ids = [aws_security_group.targets.id]

  user_data = templatefile("${path.module}/templates/user-data.sh.tftpl", {
    backend = count.index + 1
  })
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "${var.project_name}-backend-${count.index + 1}"
  }
}
