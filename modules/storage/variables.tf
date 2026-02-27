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

variable "ecs_sg_id" {
  type = string
}

variable "sessions_sg_id" {
  type = string
}

variable "subnet_private_ids" {
  type = list(string)
}
