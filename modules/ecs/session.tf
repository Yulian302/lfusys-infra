
data "aws_ami" "ec2_amis" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


resource "aws_instance" "session_service" {
  ami           = data.aws_ami.ec2_amis.id
  instance_type = "t3.nano"
  subnet_id     = var.subnet_public_id

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
  }
}
