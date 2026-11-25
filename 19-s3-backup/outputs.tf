output "bucket_name" {
  description = "S3 bucket receiving the backup archives."
  value       = aws_s3_bucket.backups.bucket
}

output "instance_id" {
  description = "EC2 backup node ID."
  value       = aws_instance.backup.id
}

output "security_group_id" {
  description = "Dedicated security group with no ingress rules."
  value       = aws_security_group.backup.id
}

output "selected_network" {
  description = "Existing network selected for the lab."
  value = {
    vpc_id            = data.aws_vpc.selected.id
    subnet_id         = data.aws_subnet.selected.id
    availability_zone = data.aws_subnet.selected.availability_zone
  }
}

output "backup_prefix" {
  value = "s3://${aws_s3_bucket.backups.bucket}/backups/"
}

output "ssm_start_session_powershell" {
  value = "aws ssm start-session --target ${aws_instance.backup.id} --region ${var.aws_region}"
}
