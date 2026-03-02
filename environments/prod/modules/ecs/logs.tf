resource "aws_cloudwatch_log_group" "gateway" {
  name              = "/ecs/${var.environment}-lfusys-gateway"
  retention_in_days = 7
}


resource "aws_cloudwatch_log_group" "sessions" {
  name              = "/ecs/${var.environment}-lfusys-sessions"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "uploads" {
  name              = "/ecs/${var.environment}-lfusys-uploads"
  retention_in_days = 7
}
