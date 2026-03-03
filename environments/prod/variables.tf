variable "region" {
  default = "eu-north-1"
}

variable "replica_region" {
  default = "eu-west-3"
}

variable "account_id" {
  default = "359952178231"
}

variable "bucket_name" {
  default = "lfusyschunks"
}

variable "project" {
  default = "lfusys"
}

variable "domain" {
  description = "Domain for the backend API"
  default     = "api.lfusys.online"
}

variable "frontend_url" {
  description = "Frontend URL for CORS and redirects"
  default     = "https://www.lfusys.online"
}

variable "enable_high_availability" {
  description = "Deploy across multiple AZs for HA (higher cost). For testing, set to false"
  type        = bool
  default     = true
}

variable "desired_count" {
  description = "Number of ECS task instances to run per service"
  type        = number
  default     = 1
}

variable "github_client_id" {
  description = "GitHub OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "github_client_secret" {
  description = "GitHub OAuth Client Secret"
  type        = string
  sensitive   = true
}

variable "google_client_id" {
  description = "Google OAuth Client ID"
  type        = string
  sensitive   = true
}

variable "google_client_secret" {
  description = "Google OAuth Client Secret"
  type        = string
  sensitive   = true
}


variable "jwt_secret_key" {
  description = "JWT Access Secret Key"
  type        = string
  sensitive   = true
}

variable "jwt_refresh_secret_key" {
  description = "JWT Refresh Secret Key"
  type        = string
  sensitive   = true
}
