
// pub/sub queue between the uploads service and session service to notify when the last chunk was uploaded
resource "aws_sqs_queue" "uploads_notifications" {
  name = "uploads_notifications"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.uploads_notifications_dlq.arn
    maxReceiveCount     = 3
  })

  tags = {
    Project = var.project

  }
}

resource "aws_sqs_queue" "uploads_notifications_dlq" {
  name = "uploads_notifications_dlq"

  tags = {
    Project = var.project

  }
}

// Policy to allow S3 send messages to SQS
resource "aws_sqs_queue_policy" "allow_s3" {
  queue_url = aws_sqs_queue.uploads_notifications.url

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "s3.amazonaws.com"
      }
      Action   = "sqs:SendMessage"
      Resource = aws_sqs_queue.uploads_notifications.arn
      Condition = {
        ArnEquals = {
          "aws:SourceArn" = var.aws_s3_lfusyschunks_arn
        }
      }
    }]
  })
}
