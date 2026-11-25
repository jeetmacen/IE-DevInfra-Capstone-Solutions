output "aws_region" {
  description = "AWS Region used by Project 17"
  value       = var.aws_region
}

output "instance_id" {
  description = "Project 17 EC2 instance ID and expected log-stream name"
  value       = aws_instance.p17.id
}

output "instance_public_ip" {
  description = "Public IP used for outbound connectivity; no inbound rules exist"
  value       = aws_instance.p17.public_ip
}

output "security_group_id" {
  description = "Project security group with no inbound rules"
  value       = aws_security_group.ec2.id
}

output "cloudwatch_log_group" {
  description = "CloudWatch log group receiving boot output"
  value       = aws_cloudwatch_log_group.boot.name
}

output "existing_vpc_id" {
  description = "Pre-provided VPC used by the EC2 instance"
  value       = data.aws_vpc.existing.id
}

output "existing_subnet_id" {
  description = "Pre-provided subnet used by the EC2 instance"
  value       = data.aws_subnet.existing.id
}

output "existing_internet_gateway_id" {
  description = "Pre-provided Internet Gateway attached to the selected VPC"
  value       = data.aws_internet_gateway.existing.id
}

output "session_manager_command" {
  description = "Connect without exposing SSH"
  value       = "aws ssm start-session --target ${aws_instance.p17.id} --region ${var.aws_region}"
}

output "log_tail_command" {
  description = "Tail the forwarded boot log"
  value       = "aws logs tail ${aws_cloudwatch_log_group.boot.name} --log-stream-names ${aws_instance.p17.id} --region ${var.aws_region}"
}
