variable "vpc_id" {
  description = "VPC ID where security group will be created"
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

variable "allow_ssh_from" {
  description = "CIDR block allowed to access SSH"
  type        = string
  default     = "0.0.0.0/0" # change to your office/public IP for security
}