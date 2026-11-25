output "instance_id" {
  description = "Monitored instance ID."
  value       = aws_instance.monitored.id
}

output "dashboard_name" {
  description = "CloudWatch dashboard name."
  value       = aws_cloudwatch_dashboard.instance.dashboard_name
}

output "dashboard_url" {
  description = "Console link to the dashboard."
  value       = "https://${var.aws_region}.console.aws.amazon.com/cloudwatch/home?region=${var.aws_region}#dashboards/dashboard/${aws_cloudwatch_dashboard.instance.dashboard_name}"
}
