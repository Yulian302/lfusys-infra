
resource "aws_ecs_task_definition" "gateway" {
  family                   = "lfusys-gateway"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "gateway"
      image     = "3022003/lfusys-gateway:latest"
      essential = true

      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]

      secrets = [
        {
          name      = "OAUTH2_GITHUB_CLIENT_ID"
          valueFrom = var.github_client_id
        },
        {
          name      = "OAUTH2_GITHUB_CLIENT_SECRET"
          valueFrom = var.github_client_secret
        },
        {
          name      = "OAUTH2_GOOGLE_CLIENT_ID"
          valueFrom = var.google_client_id
        },
        {
          name      = "OAUTH2_GOOGLE_CLIENT_SECRET"
          valueFrom = var.google_client_secret
        },
        {
          name      = "JWT_SECRET_KEY"
          valueFrom = var.jwt_secret_key
        },
        {
          name      = "JWT_REFRESH_SECRET_KEY"
          valueFrom = var.jwt_refresh_secret_key
        },
      ]

      environment = [
        { name = "ENV", value = "PROD" },
        { name = "TRACING", value = "false" },
        { name = "TRACING_ADDR", value = "jaeger:4317" },
        { name = "FRONTEND_URL", value = "https://www.lfusys.online" },
        { name = "GATEWAY_ADDR", value = ":8080" },
        { name = "CORS_ALLOWED_ORIGINS", value = "https://www.lfusys.online" },
        { name = "AWS_REGION", value = var.region },
        { name = "OAUTH2_GITHUB_REDIRECT_URI", value = "https://api.lfusys.online/api/v1/auth/github/callback" },
        { name = "OAUTH2_GITHUB_EXCHANGE_URL", value = "https://github.com/login/oauth/access_token" },
        { name = "OAUTH2_GOOGLE_REDIRECT_URI", value = "https://api.lfusys.online/api/v1/auth/google/callback" },
        { name = "OAUTH2_GOOGLE_EXCHANGE_URL", value = "https://oauth2.googleapis.com/token" },
        { name = "SESSION_GRPC_URL", value = "sessions:50051" },
        { name = "DYNAMODB_USERS_TABLE_NAME", value = "users" },
        { name = "DYNAMODB_UPLOADS_TABLE_NAME", value = "uploads" },
        { name = "REDIS_HOST", value = "redis:6379" },
      ]
    }
  ])
}

resource "aws_ecs_service" "gateway" {
  name            = "gateway-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.gateway.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.subnet_private_ids
    security_groups = [aws_security_group.ecs_sg.id]
  }

  load_balancer {
    target_group_arn = var.alb_target_group_gateway_arn
    container_name   = "gateway"
    container_port   = 8080
  }

  depends_on = [var.alb_listener_http]
}

// Auto-scaling based on CPU
resource "aws_appautoscaling_target" "gateway" {
  max_capacity       = 5
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.gateway.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "gateway_cpu" {
  name               = "gateway-cpu-scaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.gateway.resource_id
  scalable_dimension = aws_appautoscaling_target.gateway.scalable_dimension
  service_namespace  = aws_appautoscaling_target.gateway.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
