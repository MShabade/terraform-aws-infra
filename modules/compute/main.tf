provider "aws" {
  region = var.region
}

# Use SSM to get the latest Amazon Linux 2 AMI automatically
data "aws_ssm_parameter" "latest_amzn2_ami" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "this" {
  count = var.instance_count

  ami           = data.aws_ssm_parameter.latest_amzn2_ami.value
  instance_type = var.instance_type
  subnet_id     = element(var.subnet_ids, count.index % length(var.subnet_ids))
  key_name      = var.key_name
  vpc_security_group_ids = var.security_group_ids

  tags = merge(var.common_tags, {
    Name = "${var.common_tags.Project}-ec2-${count.index + 1}"
  })
}