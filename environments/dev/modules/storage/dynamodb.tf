
resource "aws_dynamodb_table" "uploads" {
  name         = "uploads"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "upload_id"

  ttl {
    attribute_name = "expires_at"
    enabled        = true
  }

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
    name = "user_email"
    type = "S"
  }

  tags = {
    Project = var.project
  }
}


resource "aws_dynamodb_table" "files" {
  name         = "files"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "file_id"

  global_secondary_index {
    name            = "owner_email-index"
    projection_type = "ALL"
    hash_key        = "owner_email"
  }

  attribute {
    name = "file_id"
    type = "S"
  }

  attribute {
    name = "owner_email"
    type = "S"
  }

  tags = {
    Project = var.project
  }
}

resource "aws_dynamodb_table" "users" {
  name         = "users"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "email"

  attribute {
    name = "email"
    type = "S"
  }

  tags = {
    Project = var.project
  }
}
