locals {
  dashboard_name = "p21-${aws_instance.monitored.id}"

  charts = [
    { title = "CPU utilization (%)", metric = "CPUUtilization", stat = "Average" },
    { title = "Network in (bytes)", metric = "NetworkIn", stat = "Sum" },
    { title = "Network out (bytes)", metric = "NetworkOut", stat = "Sum" },
    { title = "Status check failed", metric = "StatusCheckFailed", stat = "Maximum" },
  ]
}

resource "aws_cloudwatch_dashboard" "instance" {
  dashboard_name = local.dashboard_name

  dashboard_body = jsonencode({
    widgets = [
      for index, chart in local.charts : {
        type   = "metric"
        x      = (index % 2) * 12
        y      = floor(index / 2) * 6
        width  = 12
        height = 6
        properties = {
          title   = chart.title
          region  = var.aws_region
          view    = "timeSeries"
          stat    = chart.stat
          period  = var.metric_period
          metrics = [["AWS/EC2", chart.metric, "InstanceId", aws_instance.monitored.id]]
        }
      }
    ]
  })
}
