provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = var.role_arn
  }
}

module "cloudfront_distribution" {
  source = "./modules/cloudfront"

  alias                   = var.alias
  alt_alias               = var.alt_alias
  environment             = var.environment
  aws_acm_certificate_arn = var.aws_acm_certificate_arn
  domain                  = var.domain
  name_prefix             = var.name_prefix
  role_arn                = var.role_arn
  null_label_prefix       = module.sso_login_frontend_label.id
  null_label_tags         = module.sso_login_frontend_label.tags

}

module "sso_login_frontend_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.12.2"
  namespace   = "globalenglish"
  environment = var.environment
  stage       = var.name_prefix
  name        = "sso-login-frontend"

  tags = {
    Service     = "sso-login-frontend"
    Terraformed = true
  }
}

