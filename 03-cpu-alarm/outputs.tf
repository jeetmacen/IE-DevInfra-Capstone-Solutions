output "instance_id" {
  description = "ID of the monitored instance."
  value       = aws_instance.monitored.id
}

output "alarm_name" {
  description = "Name of the CloudWatch alarm."
  value       = aws_cloudwatch_metric_alarm.high_cpu.alarm_name
}

output "sns_topic_arn" {
  description = "SNS topic that sends the notifications."
  value       = aws_sns_topic.alerts.arn
}
