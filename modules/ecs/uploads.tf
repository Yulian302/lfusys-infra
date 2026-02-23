
resource "aws_ecs_task_definition" "uploads" {
  family                   = "lfusys-uploads"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "uploads"
      image     = "3022003/lfusys-uploads:latest"
      essential = true

      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]

      secrets = []

      environment = [
        { name = "ENV", value = "PROD" },
        { name = "TRACING", value = "false" },
        { name = "TRACING_ADDR", value = "jaeger:4317" },
        { name = "AWS_REGION", value = var.region },
        { name = "AWS_BUCKET_NAME", value = var.aws_bucket_name },
        { name = "AWS_ACCOUNT_ID", value = var.aws_account_id },
        { name = "UPLOADS_ADDR", value = ":8080" },
        { name = "UPLOADS_NOTIFICATIONS_QUEUE_NAME", value = "uploads_notifications" },
        { name = "DYNAMODB_UPLOADS_TABLE_NAME", value = "uploads" },
      ]
    }
  ])
}


resource "aws_ecs_service" "uploads" {
  name            = "uploads-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.uploads.id
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_private_ids
    security_groups = [aws_security_group.uploads_sg.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_uploads_arn
    container_name   = "uploads"
    container_port   = 8080
  }

  depends_on = [var.alb_listener_uploads_rule]
}
