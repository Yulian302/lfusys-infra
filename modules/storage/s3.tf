
resource "aws_s3_bucket" "lfusyschunks" {
  bucket = "lfusyschunks"

  tags = {
    Project = var.project
  }
}
