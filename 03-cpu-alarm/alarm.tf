resource "aws_sns_topic" "alerts" {
  name_prefix = "${var.project_name}-alerts-"
}

resource "aws_sns_topic_subscription" "email" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = var.alert_email
}

resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.project_name}-high-cpu-${aws_instance.monitored.id}"
  alarm_description   = "Average CPU above ${var.cpu_threshold}% for ${var.evaluation_periods} minutes"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  statistic           = "Average"
  period              = 60
  evaluation_periods  = var.evaluation_periods
  comparison_operator = "GreaterThanThreshold"
  threshold           = var.cpu_threshold
  treat_missing_data  = "missing"
  alarm_actions       = [aws_sns_topic.alerts.arn]
  ok_actions          = [aws_sns_topic.alerts.arn]

  dimensions = {
    InstanceId = aws_instance.monitored.id
  }
}
