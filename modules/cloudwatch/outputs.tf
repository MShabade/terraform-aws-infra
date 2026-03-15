# EC2 CPU Alarms
output "ec2_cpu_alarms" {
  value = [for _, a in aws_cloudwatch_metric_alarm.ec2_cpu_high : a.alarm_name]
}

# ALB Unhealthy Host Alarm
output "alb_unhealthy_alarm" {
  value = aws_cloudwatch_metric_alarm.alb_unhealthy_hosts.alarm_name
}

# RDS CPU Alarms
output "rds_cpu_alarms" {
  value = [for _, a in aws_cloudwatch_metric_alarm.rds_cpu_high : a.alarm_name]
}