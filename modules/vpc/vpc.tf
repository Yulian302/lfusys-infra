

resource "aws_vpc" "lfusysvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
    Name        = "lfusys-vpc"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.lfusysvpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
    Name        = "lfusys-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lfusysvpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-north-1a"

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
    Name        = "lfusys-subnet"
  }
}

output "vpc_id" {
  value = aws_vpc.lfusysvpc.id
}

output "subnet_public_id" {
  value = aws_subnet.public.id
}

output "subnet_private_id" {
  value = aws_subnet.private.id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lfusysvpc.id

  tags = {
    Name = "lfusys-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lfusysvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

