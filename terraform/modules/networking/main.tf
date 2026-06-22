resource "aws_vpc" "pulsefort" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "pulsefort-vpc"
  }
}

resource "aws_internet_gateway" "pulsefort" {
  vpc_id = aws_vpc.pulsefort.id

  tags = {
    Name = "pulsefort-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.pulsefort.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone
  map_public_ip_on_launch = true

  tags = {
    Name = "pulsefort-public-subnet"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.pulsefort.id

  route {
    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.pulsefort.id
  }

  tags = {
    Name = "pulsefort-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}