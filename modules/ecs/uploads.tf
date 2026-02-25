
resource "aws_ecs_task_definition" "uploads" {
  family                   = "${var.environment}-lfusys-uploads"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_uploads_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "uploads"
      image     = "359952178231.dkr.ecr.eu-north-1.amazonaws.com/lfusys-uploads-prod:latest"
      essential = true

      portMappings = [{
        containerPort = 8080
        protocol      = "tcp"
      }]

      # healthCheck = {
      #   retries = 3,
      #   command = [
      #     "CMD-SHELL",
      #     "curl -f http://localhost:8080/health/live || exit 1"
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
        { name = "CORS_ALLOWED_ORIGINS", value = var.frontend_url },
        { name = "AWS_REGION", value = var.region },
        { name = "AWS_BUCKET_NAME", value = var.aws_bucket_name },
        { name = "AWS_ACCOUNT_ID", value = var.aws_account_id },
        { name = "UPLOADS_ADDR", value = ":8080" },
        { name = "UPLOADS_NOTIFICATIONS_QUEUE_NAME", value = "${var.environment}-uploads_notifications" },
        { name = "DYNAMODB_UPLOADS_TABLE_NAME", value = "${var.environment}-uploads" },
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.uploads.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


resource "aws_ecs_service" "uploads" {
  name            = "${var.environment}-uploads-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.uploads.id
  desired_count   = var.desired_count
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


// Uploads IAM Task Role (S3, SQS)
resource "aws_iam_role" "ecs_uploads_task_role" {
  name = "${var.environment}-uploads-lfusys-ecs-task-role"

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
    Service     = "uploads"
  }
}

resource "aws_iam_role_policy_attachment" "uploads_s3_attach" {
  role       = aws_iam_role.ecs_uploads_task_role.name
  policy_arn = aws_iam_policy.s3_access.arn
}

resource "aws_iam_role_policy_attachment" "uploads_sqs_attach" {
  role       = aws_iam_role.ecs_uploads_task_role.name
  policy_arn = aws_iam_policy.sqs_access.arn
}

