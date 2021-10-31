locals {
  domain_name = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}auth"
}

resource "aws_api_gateway_rest_api" "ls_backend" {
  name        = "${var.null_label_prefix}-api"
  description = "This is the API for supporting learnship domain in login app"

  tags = var.null_label_tags
}

resource "aws_api_gateway_deployment" "ls_backend_deployment" {
  depends_on = [aws_api_gateway_integration.sso_post_integration, aws_api_gateway_integration.sso_options_integration, aws_api_gateway_integration.sso_get_integration, aws_api_gateway_integration.logout_get_integration, aws_api_gateway_integration.logout_options_integration, aws_api_gateway_integration.password_get_integration, aws_api_gateway_integration.password_options_integration, aws_api_gateway_integration.refresh_get_integration]

  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  stage_name  = var.environment

  variables = {
    # md5 of the file is computed to force deployment if resources are changed in the file
    "apigateway_md5"          = filemd5("../terraform/modules/cognito/api_gateway.tf")
    "apigateway_logout_md5"   = filemd5("../terraform/modules/cognito/api_gateway_logout.tf")
    "apigateway_password_md5" = filemd5("../terraform/modules/cognito/api_gateway_password.tf")
    "apigateway_refresh_md5"  = filemd5("../terraform/modules/cognito/api_gateway_refresh.tf")
    "apigateway_ssologin_md5" = filemd5("../terraform/modules/cognito/api_gateway_ssologin.tf")
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_domain_name" "auth_domain" {
  certificate_arn = data.terraform_remote_state.platform.outputs.acm_cloudfront_certificate_arn
  domain_name     = "${local.domain_name}.${data.terraform_remote_state.platform.outputs.domain_name}"
}

# DNS record using Route53. Route53 is not specifically required; any DNS host can be used.
resource "aws_route53_record" "api_gw_auth" {
  name    = aws_api_gateway_domain_name.auth_domain.domain_name
  type    = "A"
  zone_id = data.terraform_remote_state.platform.outputs.public_zone_id

  alias {
    evaluate_target_health = true
    name                   = aws_api_gateway_domain_name.auth_domain.cloudfront_domain_name
    zone_id                = aws_api_gateway_domain_name.auth_domain.cloudfront_zone_id
  }
}

resource "aws_api_gateway_base_path_mapping" "base_path_mapping" {
  api_id      = aws_api_gateway_rest_api.ls_backend.id
  stage_name  = aws_api_gateway_deployment.ls_backend_deployment.stage_name
  domain_name = aws_api_gateway_domain_name.auth_domain.domain_name
}
