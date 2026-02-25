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

