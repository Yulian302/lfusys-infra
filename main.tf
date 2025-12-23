
provider "aws" {
  region = "eu-north-1"
}


module "ecs" {
  source            = "./modules/ecs"
  subnet_private_id = module.vpc.subnet_private_id
  subnet_public_id  = module.vpc.subnet_public_id
}

module "storage" {
  source            = "./modules/storage"
  subnet_private_id = module.vpc.subnet_private_id
}

module "vpc" {
  source = "./modules/vpc"
}

module "queues" {
  source = "./modules/queues"
}
