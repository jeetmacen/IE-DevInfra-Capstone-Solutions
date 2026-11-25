resource "aws_instance" "backup" {
  ami                         = data.aws_ssm_parameter.al2023_ami.value
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [aws_security_group.backup.id]
  iam_instance_profile        = aws_iam_instance_profile.backup.name
  associate_public_ip_address = true

  # No key_name: SSH is not used and port 22 remains closed.
  user_data = templatefile("${path.module}/scripts/user-data.sh.tftpl", {
    bucket_name     = aws_s3_bucket.backups.bucket
    aws_region      = var.aws_region
    backup_schedule = var.backup_schedule
  })

  user_data_replace_on_change = true

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  root_block_device {
    encrypted   = true
    volume_type = "gp3"
    volume_size = 8
  }

  depends_on = [
    aws_iam_role_policy.s3_backup,
    aws_iam_role_policy_attachment.ssm,
    aws_s3_bucket_public_access_block.backups,
    aws_s3_bucket_server_side_encryption_configuration.backups
  ]

  tags = {
    Name = "${var.project_name}-backup-node"
  }
}
