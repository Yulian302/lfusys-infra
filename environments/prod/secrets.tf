

// AWS Secrets (as params for cost efficiency)
resource "aws_ssm_parameter" "github_client_id" {
  name  = "/gateway/prod/github/client-id"
  type  = "SecureString"
  value = var.github_client_id

  tags = {
    Service = "gateway"
    Project = var.project
  }
}

resource "aws_ssm_parameter" "github_client_secret" {
  name  = "/gateway/prod/github/client-secret"
  type  = "SecureString"
  value = var.github_client_secret

  tags = {
    Service = "gateway"
    Project = var.project
  }
}

resource "aws_ssm_parameter" "google_client_id" {
  name  = "/gateway/prod/google/client-id"
  type  = "SecureString"
  value = var.google_client_id

  tags = {
    Service = "gateway"
    Project = var.project
  }
}

resource "aws_ssm_parameter" "google_client_secret" {
  name  = "/gateway/prod/google/client-secret"
  type  = "SecureString"
  value = var.google_client_secret

  tags = {
    Service = "gateway"
    Project = var.project
  }
}

resource "aws_ssm_parameter" "jwt_secret" {
  name  = "/gateway/prod/jwt/secret"
  type  = "SecureString"
  value = var.jwt_secret_key

  tags = {
    Service = "gateway"
    Project = var.project
  }
}

resource "aws_ssm_parameter" "jwt_refresh_secret" {
  name  = "/gateway/prod/jwt/refresh-secret"
  type  = "SecureString"
  value = var.jwt_refresh_secret_key

  tags = {
    Service = "gateway"
    Project = var.project
  }
}


output "parameter_arns" {
  description = "ARNs of created SSM parameters"
  value = {
    github_client_id       = aws_ssm_parameter.github_client_id.arn
    github_client_secret   = aws_ssm_parameter.github_client_secret.arn
    google_client_id       = aws_ssm_parameter.google_client_id.arn
    google_client_secret   = aws_ssm_parameter.google_client_secret.arn
    jwt_secret_key         = aws_ssm_parameter.jwt_secret.arn
    jwt_refresh_secret_key = aws_ssm_parameter.jwt_refresh_secret.arn
  }
}
