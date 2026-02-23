
variable "project" {
  type = string
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
