
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


resource "aws_ecs_task_definition" "sessions" {
  family                   = "lfusys-sessions"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "sessions"
      image     = "3022003/lfusys-sessions:latest"
      essential = true

      portMappings = [{
        containerPort = 50051
        protocol      = "tcp"
      }]

      secrets = []

      environment = [
        { name = "ENV", value = "PROD" },
        { name = "TRACING", value = "false" },
        { name = "TRACING_ADDR", value = "jaeger:4317" },
        { name = "AWS_REGION", value = var.region },
        { name = "SESSION_GRPC_ADDR", value = ":50051" },
        { name = "DYNAMODB_FILES_TABLE_NAME", value = "files" },
        { name = "REDIS_HOST", value = "redis:6379" },
        { name = "UPLOADS_NOTIFICATIONS_QUEUE_NAME", value = "uploads_notifications" },
      ]
    }
  ])
}

resource "aws_ecs_service" "sessions" {
  name            = "sessions-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sessions.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_private_ids
    security_groups = [aws_security_group.sessions_sg.id]
  }
}
