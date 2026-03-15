provider "aws" {
  region = var.region
}

# ----------------------------
# EC2 CPU Alarms
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_high" {
  for_each = toset(var.ec2_instance_ids)

  alarm_name          = "EC2-${each.key}-CPUHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU exceeds 80% on EC2 ${each.key}"
  dimensions = {
    InstanceId = each.value
  }

  tags = var.common_tags
}

# ----------------------------
# ALB Unhealthy Host Alarm
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "alb_unhealthy_hosts" {
  alarm_name          = "ALB-UnhealthyHosts"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "UnHealthyHostCount"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Average"
  threshold           = 0
  alarm_description   = "ALB has unhealthy hosts"
  dimensions = {
    LoadBalancer = var.alb_arn
  }

  tags = var.common_tags
}

# ----------------------------
# RDS CPU Alarms
# ----------------------------
resource "aws_cloudwatch_metric_alarm" "rds_cpu_high" {
  for_each = toset(var.rds_instance_ids)

  alarm_name          = "RDS-${each.key}-CPUHigh"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "CPU exceeds 80% on RDS ${each.key}"
  dimensions = {
    DBInstanceIdentifier = each.value
  }

  tags = var.common_tags
}