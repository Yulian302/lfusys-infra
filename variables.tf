variable "region" {
  default = "eu-north-1"
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
