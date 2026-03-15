provider "aws" {
  region = var.region
}

# EC2 IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = var.ec2_role_name
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json

  tags = var.common_tags
}

data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# EC2 Managed Policy Example
resource "aws_iam_role_policy_attachment" "ec2_s3_attach" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# RDS IAM Role
resource "aws_iam_role" "rds_role" {
  name               = var.rds_role_name
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role.json
  tags               = var.common_tags
}

data "aws_iam_policy_document" "rds_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
  }
}

# Example RDS policy (CloudWatch logs access)
resource "aws_iam_role_policy_attachment" "rds_cloudwatch_attach" {
  role       = aws_iam_role.rds_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"
}

# S3 Role (can be attached to Lambda/EC2)
resource "aws_iam_role" "s3_role" {
  name               = var.s3_role_name
  assume_role_policy = data.aws_iam_policy_document.s3_assume_role.json
  tags               = var.common_tags
}

data "aws_iam_policy_document" "s3_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Attach S3 full access (example, adjust as per company policy)
resource "aws_iam_role_policy_attachment" "s3_full_access_attach" {
  role       = aws_iam_role.s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}