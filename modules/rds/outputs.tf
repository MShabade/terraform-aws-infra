output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.rds.endpoint
}

output "rds_address" {
  description = "RDS address"
  value       = aws_db_instance.rds.address
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.rds.port
}

output "rds_security_group_id" {
  description = "RDS security group"
  value       = aws_security_group.rds_sg.id
}