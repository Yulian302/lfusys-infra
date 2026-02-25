
# DynamoDB access policy
resource "aws_iam_policy" "dynamodb_access" {
  name = "${var.environment}-dynamodb-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:BatchGetItem",
          "dynamodb:BatchWriteItem",
          "dynamodb:DeleteItem",
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:Query",
          "dynamodb:Scan",
          "dynamodb:UpdateItem",
          "dynamodb:DescribeTable"
        ]
        Resource = [
          "arn:aws:dynamodb:${var.region}:${var.aws_account_id}:table/${var.environment}-*",
        ]
      }
    ]
  })
}

# S3 access policy
resource "aws_iam_policy" "s3_access" {
  name = "${var.environment}-s3-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:AbortMultipartUpload"
        ]
        Resource = [
          "arn:aws:s3:::${var.environment}-lfusyschunks",
        ]
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:CopyObject",
          "s3:HeadObject",
          "s3:GetObjectAttributes"
        ]
        Resource = [
          "arn:aws:s3:::${var.environment}-lfusyschunks/*",
        ]
      }
    ]
  })
}

# SQS access policy
resource "aws_iam_policy" "sqs_access" {
  name = "${var.environment}-sqs-access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sqs:SendMessage",
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes",
          "sqs:GetQueueUrl",
          "sqs:ChangeMessageVisibility"
        ]
        Resource = [
          "arn:aws:sqs:${var.region}:${var.aws_account_id}:${var.environment}-uploads_notifications",
          "arn:aws:sqs:${var.region}:${var.aws_account_id}:${var.environment}-uploads_notifications*",
        ]
      }
    ]
  })
}

# Redis data access
resource "aws_iam_policy" "redis_data_access" {
  name        = "${var.environment}-redis-data-access"
  description = "Policy for Redis data read/write operations"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticache:Connect"
        ]
        Resource = [
          "arn:aws:elasticache:${var.region}:${var.aws_account_id}:cluster:${var.environment}-lfusys-redis",
          "arn:aws:elasticache:${var.region}:${var.aws_account_id}:user:${var.environment}-redis-user"
        ]
      }
    ]
  })
}
