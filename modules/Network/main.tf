resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr
  tags = { Name = "${var.environment}-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.public_subnet_cidr
  availability_zone = "${var.region}a"
  map_public_ip_on_launch = true
  tags = { Name = "${var.environment}-public-subnet" }
}

resource "aws_subnet" "private" {
  vpc_id = aws_vpc.this.id
  cidr_block = var.private_subnet_cidr
  availability_zone = "${var.region}b"
  tags = { Name = "${var.environment}-private-subnet" }
}

resource "aws_internet_gateway" "igw" { vpc_id = aws_vpc.this.id }

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  route { cidr_block = "0.0.0.0/0"; gateway_id = aws_internet_gateway.igw.id }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}