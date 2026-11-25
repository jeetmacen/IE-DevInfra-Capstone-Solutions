output "url" {
  description = "Load balancer URL."
  value       = "http://${aws_lb.web.dns_name}/"
}

output "target_group_arn" {
  description = "ARN of the target group."
  value       = aws_lb_target_group.web.arn
}

output "instance_ids" {
  description = "Backend instance IDs."
  value       = aws_instance.backend[*].id
}
