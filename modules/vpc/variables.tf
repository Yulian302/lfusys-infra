
variable "project" {
  type = string
}

variable "environment" {
  type = string
  description = "Environment name (e.g., dev, prod)"
}

variable "enable_high_availability" {
  type = bool
  description = "Deploy across multiple AZs for HA (higher cost). For dev/test, set to false"
  default = true
}
