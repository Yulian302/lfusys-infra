// Virtual private cloud (VPC) with public and private subnets. Each subnet with 2 AZ (Availability zones)
// VPC
resource "aws_vpc" "lfusysvpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Project = var.project

    Name = "${var.project}-vpc"
  }
}

data "aws_availability_zones" "available" {}

// PUB Subnets (2 AZ)
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.lfusysvpc.id
  cidr_block              = cidrsubnet(aws_vpc.lfusysvpc.cidr_block, 8, count.index)
  availability_zone       = data.aws_availability_zones.available.names[count.index]
  map_public_ip_on_launch = true

  tags = {
    Project = var.project

    Name = "${var.project}-subnet-public-${count.index}"
  }
}

// PRIV Subnets (2 AZ)
resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.lfusysvpc.id
  cidr_block        = cidrsubnet(aws_vpc.lfusysvpc.cidr_block, 8, count.index + 10)
  availability_zone = data.aws_availability_zones.available.names[count.index]

  tags = {
    Project = var.project

    Name = "${var.project}-subnet-private-${count.index}"
  }
}

// INET Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.lfusysvpc.id

  tags = {
    Name = "${var.project}-igw"
  }
}

// PUB Route table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.lfusysvpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

// Route table association for PUB subnets
resource "aws_route_table_association" "public_assoc" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}


// NAT Gateway
resource "aws_eip" "lfusys-nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "lfusys-nat" {
  allocation_id = aws_eip.lfusys-nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.project}-nat"
  }
}


// PRIV Route table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.lfusysvpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.lfusys-nat.id
  }
}


// Route table association for PRIV subnets
resource "aws_route_table_association" "private_assoc" {
  count          = 2
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}
