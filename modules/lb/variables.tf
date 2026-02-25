
variable "project" {
  type = string
}

variable "environment" {
  type = string
  description = "Environment name (e.g., dev, prod)"
}

variable "vpc_id" {
  type = string
}

variable "subnet_public_ids" {
  type = list(string)
}

variable "certificate_arn" {
  type = string
}
