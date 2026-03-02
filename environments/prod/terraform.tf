terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }


  required_version = ">= 0.12"

  # // backend for managing states
  backend "s3" {
    bucket  = "lfusys-terraform-state"
    key     = "terraform.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}
