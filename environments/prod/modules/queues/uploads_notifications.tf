
// pub/sub queue between the uploads service and session service to notify when the last chunk was uploaded
resource "aws_sqs_queue" "uploads_notifications" {
  name = "${var.environment}-uploads_notifications"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.uploads_notifications_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Project = var.project

  }
}

resource "aws_sqs_queue" "uploads_notifications_dlq" {
  name       = "${var.environment}-uploads_notifications_dlq"
  fifo_queue = true

  tags = {
    Project = var.project

  }
}
