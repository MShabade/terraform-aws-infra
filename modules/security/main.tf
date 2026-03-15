provider "aws" {
  region = "eu-west-1"  # match your VPC
}

# Security Group for EC2
resource "aws_security_group" "ec2_sg" {
  name        = "ec2-sg-${var.common_tags.Environment}"
  description = "Security group for EC2 instances"
  vpc_id      = var.vpc_id

  tags = merge(var.common_tags, {
    Name = "ec2-sg-${var.common_tags.Environment}"
  })
}

# Allow SSH
resource "aws_security_group_rule" "ssh_inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [var.allow_ssh_from]
  security_group_id = aws_security_group.ec2_sg.id
}

# Allow all outbound
resource "aws_security_group_rule" "all_outbound" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ec2_sg.id
}