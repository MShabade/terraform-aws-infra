variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  type = string
}

variable "common_tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "my-project"
    Owner       = "team-name"
  }
}