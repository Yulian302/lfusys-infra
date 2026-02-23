
// main cluster
resource "aws_ecs_cluster" "main" {
  name = "lfusys-cluster"
}

// ECS Security Group (allow traffic from ALB over :8080, no outbound rules)
resource "aws_security_group" "ecs_sg" {
  name   = "lfusys-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

// Uploads security group
resource "aws_security_group" "uploads_sg" {
  name   = "lfusys-uploads-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
