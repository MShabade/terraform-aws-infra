output "ec2_role_arn" {
  value = aws_iam_role.ec2_role.arn
}

output "rds_role_arn" {
  value = aws_iam_role.rds_role.arn
}

output "s3_role_arn" {
  value = aws_iam_role.s3_role.arn
}

output "lambda_role_arn" {
  description = "IAM role ARN for Lambda"
  value       = aws_iam_role.lambda_role.arn
}