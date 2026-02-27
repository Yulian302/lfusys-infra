# Production environment variables for Terraform
# Override defaults from variables.tf for prod deployment

# AWS region (same as dev, or change if needed)
region =

# DynamoDB region for read-only replicas
replica_region =

# AWS account ID (same as dev)
account_id =

# S3 bucket name (prefixed for prod to avoid conflicts)
bucket_name =

# Project name
project =

# Domain for prod API (update DNS accordingly)
domain =

# Frontend URL for prod
frontend_url =

# Cost optimization for first prod deployment
# AWS ALB requires 2 subnets in different AZs (AWS hard requirement)
# Keeping HA enabled for ALB, but only 1 ECS task to minimize compute costs
enable_high_availability =

# ECS desired count: set to 1 for cost savings, increase to 2+ for production HA
desired_count =

# Sensitive variables - update with your actual prod values (these appear to be dev/test values)
github_client_id       =
github_client_secret   =
google_client_id       =
google_client_secret   =
jwt_secret_key         =
jwt_refresh_secret_key =
