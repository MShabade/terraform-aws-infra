variable "lambda_name" {
  description = "Lambda function name"
  type        = string
}

variable "handler" {
  description = "Lambda handler"
  type        = string
}

variable "runtime" {
  description = "Lambda runtime"
  type        = string
}

variable "role_arn" {
  description = "IAM Role ARN for Lambda"
  type        = string
}

variable "s3_bucket" {
  description = "S3 bucket where Lambda zip is stored"
  type        = string
}

variable "s3_key" {
  description = "S3 object key for Lambda zip"
  type        = string
}

variable "common_tags" {
  description = "Common tags for Lambda"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}