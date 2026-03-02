output "bucket_id" {
  value = aws_s3_bucket.lfusyschunks.id
}

output "bucket_arn" {
  value = aws_s3_bucket.lfusyschunks.arn
}


resource "aws_s3_bucket" "lfusyschunks" {
  bucket = "lfusyschunks"


  tags = {
    Project = var.project
  }
}

resource "aws_s3_bucket_notification" "chunk_upload_complete" {
  bucket = aws_s3_bucket.lfusyschunks.id

  queue {
    queue_arn     = var.upload_notifications_queue_arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "uploads/"
  }
}

resource "aws_s3_bucket_ownership_controls" "chunks" {
  bucket = aws_s3_bucket.lfusyschunks.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

