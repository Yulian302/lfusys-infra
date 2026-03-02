output "bucket_id" {
  value = aws_s3_bucket.lfusyschunks.id
}

output "bucket_arn" {
  value = aws_s3_bucket.lfusyschunks.arn
}


resource "aws_s3_bucket" "lfusyschunks" {
  bucket = "${var.environment}-lfusyschunks"

  tags = {
    Project = var.project
  }
}

resource "aws_s3_bucket_ownership_controls" "chunks" {
  bucket = aws_s3_bucket.lfusyschunks.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_cors_configuration" "lfusyschunks-fronend-cors" {
  bucket = aws_s3_bucket.lfusyschunks.id

  cors_rule {
    allowed_headers = []
    allowed_methods = ["GET"]
    allowed_origins = ["*"]
    expose_headers  = []
  }
}
