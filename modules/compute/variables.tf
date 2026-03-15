variable "region" {
  description = "AWS region to deploy resources in"
  type        = string
  default     = "eu-west-1"
}

variable "vpc_id" {
  description = "VPC ID where EC2 instances will be launched"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs for EC2 deployment"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security groups to attach to EC2 instances"
  type        = list(string)
  default     = []
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Key pair name for SSH access"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}

variable "instance_count" {
  description = "Number of EC2 instances to create"
  type        = number
  default     = 1
}