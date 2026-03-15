output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "rds_role_arn" {
  value = aws_iam_role.rds_role.arn
}

output "s3_role_arn" {
  value = aws_iam_role.s3_role.arn
}