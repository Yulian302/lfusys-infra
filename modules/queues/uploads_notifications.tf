
// pub/sub queue between the uploads service and session service to notify when the last chunk was uploaded
resource "aws_sqs_queue" "uploads_notifications" {
  name       = "uploads_notifications.fifo"
  fifo_queue = true

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.uploads_notifications_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
  }
}

resource "aws_sqs_queue" "uploads_notifications_dlq" {
  name       = "uploads_notifications_dlq.fifo"
  fifo_queue = true

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
  }
}
