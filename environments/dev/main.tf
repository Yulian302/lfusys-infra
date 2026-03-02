// AWS settings
provider "aws" {
  region = var.region
}

// Modules
module "queues" {
  source = "./modules/queues"

  project                 = var.project
  aws_s3_lfusyschunks_arn = module.storage.aws_s3_lfusyschunks_arn
}

module "storage" {
  source = "./modules/storage"

  upload_notifications_queue_arn = module.queues.upload_notifications_queue_arn
  project                        = var.project
}
