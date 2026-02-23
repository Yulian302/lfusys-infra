// AWS settings
provider "aws" {
  region = var.region
}

// register domain with Route53
data "aws_route53_zone" "main" {
  name = var.domain
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain
  validation_method = "DNS"
}

resource "aws_route53_record" "cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }
  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.main.zone_id
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.domain
  type    = "A"
  alias {
    name                   = module.lb.alb_dns_name
    zone_id                = module.lb.alb_zone_id
    evaluate_target_health = true
  }
}

// Modules
module "ecs" {
  source = "./modules/ecs"

  region          = var.region
  aws_account_id  = var.account_id
  aws_bucket_name = var.bucket_name

  vpc_id             = module.vpc.vpc_id
  subnet_private_ids = module.vpc.subnet_private_ids

  alb_sg_id                    = module.lb.alb_sg_id
  alb_target_group_gateway_arn = module.lb.alb_target_group_gateway_arn
  alb_target_group_uploads_arn = module.lb.alb_target_group_uploads_arn
  alb_listener_uploads_rule    = module.lb.alb_listener_uploads_rule
  alb_listener_http            = module.lb.alb_listener_https

  // secrets
  github_client_id       = aws_ssm_parameter.github_client_id.arn
  github_client_secret   = aws_ssm_parameter.github_client_secret.arn
  google_client_id       = aws_ssm_parameter.google_client_id.arn
  google_client_secret   = aws_ssm_parameter.google_client_secret.arn
  jwt_secret_key         = aws_ssm_parameter.jwt_secret.arn
  jwt_refresh_secret_key = aws_ssm_parameter.jwt_refresh_secret.arn
  aws_access_key_id      = ""
  aws_secret_access_key  = ""
}

module "lb" {
  source = "./modules/lb"

  vpc_id            = module.vpc.vpc_id
  project           = var.project
  subnet_public_ids = module.vpc.subnet_public_ids

  certificate_arn = aws_acm_certificate.cert.arn
}

module "queues" {
  source = "./modules/queues"

  project = var.project
}

module "storage" {
  source = "./modules/storage"

  vpc_id             = module.vpc.vpc_id
  ecs_sg_id          = module.ecs.ecs_sg_id
  sessions_sg_id     = module.ecs.sessions_sg_id
  subnet_private_ids = module.vpc.subnet_private_ids
  project            = var.project
}

module "vpc" {
  source = "./modules/vpc"

  project = var.project
}
