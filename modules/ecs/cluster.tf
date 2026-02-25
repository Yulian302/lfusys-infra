
// main cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.environment}-lfusys-cluster"

  service_connect_defaults {
    namespace = aws_service_discovery_private_dns_namespace.lfusys.arn
  }
}

// ECS Security Group (allow traffic from ALB over :8080, no outbound rules)
resource "aws_security_group" "ecs_sg" {
  name   = "${var.environment}-lfusys-ecs-sg"
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
  name   = "${var.environment}-lfusys-uploads-sg"
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

resource "aws_security_group" "sessions_sg" {
  name   = "lfusys-sessions-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port       = 50051
    to_port         = 50051
    protocol        = "tcp"
    security_groups = [aws_security_group.ecs_sg.id] # gateway SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



// Namespace for service connect
resource "aws_service_discovery_private_dns_namespace" "lfusys" {
  name = "${var.environment}.lfusys.local"
  vpc  = var.vpc_id
}
