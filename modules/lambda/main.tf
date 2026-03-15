resource "aws_lambda_function" "this" {
  function_name = var.lambda_name
  handler       = var.handler
  runtime       = var.runtime
  role          = var.role_arn

  s3_bucket = var.s3_bucket
  s3_key    = var.s3_key

  tags = var.common_tags
}