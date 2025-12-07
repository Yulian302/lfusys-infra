

resource "aws_security_group" "lfusys-allowallipv4" {
  vpc_id      = aws_vpc.lfusysvpc.id
  name        = "lfusys-vpc-security-group"
  description = "Security group for lfusys VPC"


  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
    Name        = "lfusys-vpc-security-group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.lfusys-allowallipv4.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
