
resource "aws_dynamodb_table" "uploads" {
  name         = "uploads"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "upload_id"
  range_key    = "created_at"

  global_secondary_index {
    name            = "user_email-index"
    projection_type = "ALL"
    hash_key        = "user_email"
  }

  attribute {
    name = "upload_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "user_email"
    type = "S"
  }

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
  }
}


resource "aws_dynamodb_table" "files" {
  name         = "files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "file_id"
  range_key    = "created_at"

  attribute {
    name = "file_id"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  tags = {
    Project     = "lfusys"
    Environment = "dev"
    Owner       = "Yulian"
  }
}

