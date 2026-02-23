
resource "aws_security_group" "redis_sg" {
  name   = "lfusys-redis-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow Redis from Gateway"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.ecs_sg_id]
  }

  ingress {
    description     = "Allow Redis from Sessions"
    from_port       = 6379
    to_port         = 6379
    protocol        = "tcp"
    security_groups = [var.sessions_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "lfusys-redis-subnet-group"
  subnet_ids = var.subnet_private_ids
}

resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "lfusys-redis"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  port                 = 6379
  security_group_ids   = [aws_security_group.redis_sg.id]
  subnet_group_name    = aws_elasticache_subnet_group.redis.name
}
