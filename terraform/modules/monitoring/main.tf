resource "aws_cloudwatch_log_group" "backend" {
  name              = "/starttech/backend"
  retention_in_days = 14
  tags              = { Name = "${var.app_name}-backend-logs" }
}

resource "aws_cloudwatch_log_group" "application" {
  name              = "/starttech/application"
  retention_in_days = 14
  tags              = { Name = "${var.app_name}-app-logs" }
}

resource "aws_cloudwatch_metric_alarm" "alb_5xx" {
  alarm_name          = "${var.app_name}-alb-5xx"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_ELB_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "ALB 5XX errors exceeded 10"
  dimensions          = { LoadBalancer = var.alb_arn_suffix }
}