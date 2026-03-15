variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "common_tags" {
  description = "Common tags for IAM resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

variable "ec2_role_name" {
  description = "IAM role name for EC2 instances"
  type        = string
  default     = "ec2-role"
}

variable "rds_role_name" {
  description = "IAM role name for RDS"
  type        = string
  default     = "rds-role"
}

variable "s3_role_name" {
  description = "IAM role name for S3 access"
  type        = string
  default     = "s3-role"
}