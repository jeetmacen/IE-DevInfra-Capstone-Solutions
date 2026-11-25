output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_region" {
  value = var.aws_region
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}

output "default_subnet_id" {
  value = aws_instance.project23.subnet_id
}

output "instance_id" {
  value = aws_instance.project23.id
}

output "instance_state" {
  value = aws_instance.project23.instance_state
}

output "public_ip" {
  value = aws_instance.project23.public_ip
}

output "iam_role_name" {
  value = aws_iam_role.ec2_role.name
}

output "iam_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "instance_profile_name" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "security_group_id" {
  value = aws_security_group.ec2.id
}
