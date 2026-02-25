
resource "aws_ecs_task_definition" "sessions" {
  family                   = "${var.environment}-lfusys-sessions"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_sessions_task_role.arn


  container_definitions = jsonencode([
    {
      name      = "sessions"
      image     = "359952178231.dkr.ecr.eu-north-1.amazonaws.com/lfusys-sessions-prod:latest"
      essential = true

      portMappings = [{
        name          = "grpc"
        containerPort = 50051
        protocol      = "tcp"
      }]

      # healthCheck = {
      #   retries = 3,
      #   command = [
      #     "CMD-SHELL",
      #     "/usr/local/bin/grpc_health_probe -addr=localhost:50051 || exit 1"
      #   ],
      #   timeout     = 5,
      #   interval    = 30,
      #   startPeriod = 60
      # }


      secrets = []

      environment = [
        { name = "ENV", value = var.environment },
        { name = "TRACING", value = "false" },
        { name = "TRACING_ADDR", value = "jaeger:4317" },
        { name = "AWS_REGION", value = var.region },
        { name = "AWS_BUCKET_NAME", value = var.aws_bucket_name },
        { name = "SESSION_GRPC_ADDR", value = ":50051" },
        { name = "DYNAMODB_UPLOADS_TABLE_NAME", value = "${var.environment}-uploads" },
        { name = "DYNAMODB_FILES_TABLE_NAME", value = "${var.environment}-files" },
        { name = "REDIS_HOST", value = "${var.redis_host}:6379" },
        { name = "UPLOADS_NOTIFICATIONS_QUEUE_NAME", value = "${var.environment}-uploads_notifications" },
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.sessions.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "sessions" {
  name            = "${var.environment}-sessions-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.sessions.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.subnet_private_ids
    security_groups  = [aws_security_group.sessions_sg.id]
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_private_dns_namespace.lfusys.arn
    service {
      port_name      = "grpc"
      discovery_name = "sessions"

      client_alias {
        port     = 50051
        dns_name = "sessions"
      }
    }
  }
}


// Sessions IAM Task Role (Dynamo, S3, SQS, Redis)
resource "aws_iam_role" "ecs_sessions_task_role" {
  name = "${var.environment}-sessions-lfusys-ecs-task-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })

  tags = {
    Project     = var.project
    Environment = var.environment
    Service     = "sessions"
  }
}


resource "aws_iam_role_policy_attachment" "sessions_dynamo_attach" {
  role       = aws_iam_role.ecs_sessions_task_role.name
  policy_arn = aws_iam_policy.dynamodb_access.arn
}

resource "aws_iam_role_policy_attachment" "sessions_sqs_attach" {
  role       = aws_iam_role.ecs_sessions_task_role.name
  policy_arn = aws_iam_policy.sqs_access.arn
}

resource "aws_iam_role_policy_attachment" "sessions_s3_attach" {
  role       = aws_iam_role.ecs_sessions_task_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_role_policy_attachment" "sessions_redis_attach" {
  role       = aws_iam_role.ecs_sessions_task_role.name
  policy_arn = aws_iam_policy.redis_data_access.arn
}


