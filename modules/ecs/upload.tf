

resource "aws_instance" "upload_worker" {
  ami           = data.aws_ami.ec2_amis.id
  count         = 2
  instance_type = "t3.nano"
  subnet_id     = var.subnet_private_id

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
  }
}
