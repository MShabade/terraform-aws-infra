provider "aws" {
  region = var.region
}

# Fetch availability zones
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags = merge(var.common_tags, {
    Name = "vpc-main"
  })
}

# Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, {
    Name = "igw-main"
  })
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each = { for idx, cidr in var.public_subnets : idx => cidr }

  vpc_id                  = aws_vpc.this.id
  cidr_block              = each.value
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[each.key % length(data.aws_availability_zones.available.names)]
  tags = merge(var.common_tags, {
    Name = "public-${each.key + 1}"
  })
}

# Private Subnets
resource "aws_subnet" "private" {
  for_each = { for idx, cidr in var.private_subnets : idx => cidr }

  vpc_id            = aws_vpc.this.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[each.key % length(data.aws_availability_zones.available.names)]
  tags = merge(var.common_tags, {
    Name = "private-${each.key + 1}"
  })
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags = merge(var.common_tags, {
    Name = "rt-public"
  })
}

# Route to Internet via IGW
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# Associate public subnets
resource "aws_route_table_association" "public_assoc" {
  for_each = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# NAT Gateway: one per public subnet (multi-AZ)
resource "aws_eip" "nat" {
  for_each = aws_subnet.public
  tags = merge(var.common_tags, {
    Name = "nat-eip-${each.key + 1}"
  })
}

resource "aws_nat_gateway" "this" {
  for_each      = aws_subnet.public
  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = each.value.id
  tags = merge(var.common_tags, {
    Name = "nat-gateway-${each.key + 1}"
  })
}

# Private Route Tables: one per private subnet
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.this.id
  tags = merge(var.common_tags, {
    Name = "rt-private-${each.key + 1}"
  })
}

# Private route via NAT in same AZ
resource "aws_route" "private_nat" {
  for_each = aws_subnet.private
  route_table_id         = aws_route_table.private[each.key].id
  destination_cidr_block = "0.0.0.0/0"

  nat_gateway_id = aws_nat_gateway.this[
    index([for s in aws_subnet.public : s.availability_zone], each.value.availability_zone)
  ].id
}

# Associate private subnets with their route table
resource "aws_route_table_association" "private_assoc" {
  for_each = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}