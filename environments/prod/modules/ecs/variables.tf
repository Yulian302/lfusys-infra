variable "region" {
  type = string
}

# database replica region (reads-only)
variable "replica_region" {
  type = string
}

variable "project" {
  type = string
}

variable "environment" {
  type        = string
  description = "Environment name (e.g., dev, prod)"
}

variable "vpc_id" {
  type = string
}

variable "aws_account_id" {
  type = string
}

variable "subnet_private_ids" {
  description = "List of private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "alb_sg_id" {
  description = "ALB security group id"
  type        = string
}

variable "alb_target_group_gateway_arn" {
  description = "ALB target group (gateway) arn"
  type        = string
}

variable "alb_target_group_uploads_arn" {
  description = "ALB target group (uploads) arn"
  type        = string
}

variable "alb_listener_http" {
  type = any
}

variable "alb_listener_uploads_rule" {
  type = any
}

// secrets used by services
variable "github_client_id" {
  type = string
}

variable "github_client_secret" {
  type = string
}


variable "google_client_id" {
  type = string
}

variable "google_client_secret" {
  type = string
}

variable "jwt_secret_key" {
  type = string
}

variable "jwt_refresh_secret_key" {
  type = string
}

variable "aws_access_key_id" {
  type    = string
  default = ""
}

variable "aws_secret_access_key" {
  type    = string
  default = ""
}

variable "aws_bucket_name" {
  type = string
}

variable "domain" {
  type        = string
  description = "Domain for the API"
}

variable "frontend_url" {
  type        = string
  description = "Frontend URL for CORS and redirects"
}

variable "redis_host" {
  type        = string
  description = "Redis host endpoint"
}

variable "desired_count" {
  type        = number
  description = "Number of ECS task instances to run"
  default     = 1
}

variable "uploads_notifications_queue_name" {
  type = string
}

variable "bucket_id" {
  type = string
}

variable "bucket_arn" {
  type = string
}
