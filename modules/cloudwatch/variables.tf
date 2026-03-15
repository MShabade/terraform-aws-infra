variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "common_tags" {
  description = "Common tags for CloudWatch resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

variable "ec2_instance_ids" {
  description = "List of EC2 instance IDs to monitor"
  type        = list(string)
}

variable "alb_arn" {
  description = "ALB ARN for monitoring"
  type        = string
}

variable "rds_instance_ids" {
  description = "List of RDS instance IDs to monitor"
  type        = list(string)
}