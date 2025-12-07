


resource "aws_instance" "gateway" {
  ami           = data.aws_ami.ec2_amis.id
  instance_type = "t3.nano"
  subnet_id     = var.subnet_public_id
  key_name      = "lfusys-admin"

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
    Name        = "lfusys-services-gateway"
  }
}
