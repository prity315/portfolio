resource "aws_cognito_user_pool" "user_pool" {
  name             = "${var.null_label_prefix}-${var.cognito_user_pool_name}"
  alias_attributes = ["email", "preferred_username"]

  password_policy {
    minimum_length                   = 6
    require_lowercase                = false
    require_numbers                  = false
    require_symbols                  = false
    require_uppercase                = false
    temporary_password_validity_days = 7
  }

  schema {
    name                     = "edgeUid"
    attribute_data_type      = "Number"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    number_attribute_constraints {
      max_value = 999999999
      min_value = 0
    }
  }

  schema {
    name                     = "status"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 1
      max_length = 15
    }
  }

  schema {
    name                     = "geId"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 4
      max_length = 40
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "email"
    required            = true
    mutable             = true
    string_attribute_constraints {
      max_length = "2048"
      min_length = "5"
    }
  }

  schema {
    attribute_data_type = "String"
    name                = "preferred_username"
    required            = true
    mutable             = true
    string_attribute_constraints {
      max_length = "250"
      min_length = "4"
    }
  }

  schema {
    name                     = "uuid"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 40
    }
  }

  # To identify user creation.
  schema {
    name                     = "source"
    attribute_data_type      = "String"
    developer_only_attribute = false
    mutable                  = true
    required                 = false
    string_attribute_constraints {
      min_length = 0
      max_length = 30
    }
  }

  lambda_config {
    user_migration                 = aws_lambda_function.user_migration.arn //user_migration is the lambda function name
    define_auth_challenge          = aws_lambda_function.define_auth_challenge.arn
    create_auth_challenge          = aws_lambda_function.create_auth_challenge.arn
    verify_auth_challenge_response = aws_lambda_function.verify_auth_challenge.arn
    pre_token_generation           = aws_lambda_function.pre_token_generation.arn
  }
  # Username is made case-insensitive as the same is followed in GE system.
  username_configuration {
    case_sensitive = false
  }

  tags = var.null_label_tags
}

# Creates App client for frontend(sso-login-frontend) in the Cognito user pool
resource "aws_cognito_user_pool_client" "app-client" {
  name                                 = var.environment == "production" || var.environment == "staging" ? "login-ui" : "${var.null_label_prefix}-login-ui"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = false //To use it with JS AWS-SDK
  explicit_auth_flows                  = var.auth_flows_for_login_ui
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = [var.callback_url]
  logout_urls                          = [var.sign_out_url]
  supported_identity_providers         = var.supported_idp
  allowed_oauth_flows                  = var.oauth_flows
  allowed_oauth_scopes                 = var.oauth_scopes
}

# Creates App client for ge-home(legacy app) in the Cognito user pool
resource "aws_cognito_user_pool_client" "app-client-ge-home" {
  name                                 = var.environment == "production" || var.environment == "staging" ? "ge-home" : "${var.null_label_prefix}-ge-home"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = true //To use it with backend AWS-SDK
  explicit_auth_flows                  = var.auth_flows_for_ge_home
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = [var.callback_url]
  logout_urls                          = [var.sign_out_url]
  supported_identity_providers         = var.supported_idp
  allowed_oauth_flows                  = var.oauth_flows
  allowed_oauth_scopes                 = var.oauth_scopes
}

# Creates App client for ge-platform(legacy app) in the Cognito user pool
resource "aws_cognito_user_pool_client" "app-client-ge-platform" {
  name                                 = var.environment == "production" || var.environment == "staging" ? "ge-platform" : "${var.null_label_prefix}-ge-platform"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = true //To use it with backend AWS-SDK
  explicit_auth_flows                  = var.auth_flows_refresh_token
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = [var.callback_url]
  logout_urls                          = [var.sign_out_url]
  supported_identity_providers         = var.supported_idp
  allowed_oauth_flows                  = var.oauth_flows
  allowed_oauth_scopes                 = var.oauth_scopes
}

# Creates App client for SSO in the Cognito user pool
resource "aws_cognito_user_pool_client" "app_client_sso" {
  name                                 = var.environment == "production" || var.environment == "staging" ? "sso-login-svc" : "${var.null_label_prefix}-sso-login-svc"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = true
  explicit_auth_flows                  = var.auth_flows_for_ge_home
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = [var.callback_url]
  logout_urls                          = [var.sign_out_url]
  supported_identity_providers         = [aws_cognito_identity_provider.saml_identity_provider_merck.provider_name, aws_cognito_identity_provider.saml_identity_provider_teva.provider_name, aws_cognito_identity_provider.saml_identity_provider_marvell.provider_name]
  allowed_oauth_flows                  = var.oauth_flows_sso_client
  allowed_oauth_scopes                 = var.oauth_scopes
}

# Creates App client for auth-svc in the Cognito user pool
resource "aws_cognito_user_pool_client" "app_client_auth_svc" {
  name                                 = var.environment == "production" || var.environment == "staging" ? "auth-svc" : "${var.null_label_prefix}-auth-svc"
  user_pool_id                         = aws_cognito_user_pool.user_pool.id
  generate_secret                      = true //To use it with backend AWS-SDK
  explicit_auth_flows                  = var.auth_flows_for_ge_home
  allowed_oauth_flows_user_pool_client = true
  callback_urls                        = [var.callback_url]
  logout_urls                          = [var.sign_out_url]
  supported_identity_providers         = var.supported_idp
  allowed_oauth_flows                  = var.oauth_flows
  allowed_oauth_scopes                 = var.oauth_scopes
}

# Creates the Domain for the Cognito user pool
resource "aws_cognito_user_pool_domain" "domain" {
  domain       = "${var.null_label_prefix}-${var.domain}"
  user_pool_id = aws_cognito_user_pool.user_pool.id
}

locals {
  name = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}sso"
}

# Creates the custom domain for SSO client
resource "aws_cognito_user_pool_domain" "sso_domain" {
  domain          = "${local.name}.${data.terraform_remote_state.platform.outputs.domain_name}"
  certificate_arn = data.terraform_remote_state.platform.outputs.acm_cloudfront_certificate_arn
  user_pool_id    = aws_cognito_user_pool.user_pool.id
}

# SAML Identity Provider configuration with the Cognito user pool for the Merck client.
# It is added just for testing purpose.
resource "aws_cognito_identity_provider" "saml_identity_provider_merck" {
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  provider_name   = "Merck"
  provider_type   = "SAML"
  idp_identifiers = ["merck"]

  provider_details = {
    MetadataURL           = "https://testmercklogin.globalenglish.com/saml2/idp/metadata.php"
    SLORedirectBindingURI = "ignored"
    SSORedirectBindingURI = "ignored"
    IDPSignout            = true
  }

  # SLORedirectBindingURI and SSORedirectBindingURI are populated from MetadataURL automatically.
  # This is done to avoid getting pending changes in terraform plan in each deployment.
  lifecycle {
    ignore_changes = [
      provider_details["SLORedirectBindingURI"],
      provider_details["SSORedirectBindingURI"]
    ]
  }

  attribute_mapping = {
    email              = "EmailAddress"
    preferred_username = "EmailAddress"
  }
}

# SAML Identity Provider configuration with the Cognito user pool for the client Teva Pharmaceutical
resource "aws_cognito_identity_provider" "saml_identity_provider_teva" {
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  provider_name   = "Teva"
  provider_type   = "SAML"
  idp_identifiers = ["teva"]

  provider_details = {
    MetadataURL           = var.metadata_url
    SLORedirectBindingURI = "ignored"
    SSORedirectBindingURI = "ignored"
    IDPSignout            = true
  }

  # SLORedirectBindingURI and SSORedirectBindingURI are populated from MetadataURL automatically.
  # This is done to avoid getting pending changes in terraform plan in each deployment.
  lifecycle {
    ignore_changes = [
      provider_details["SLORedirectBindingURI"],
      provider_details["SSORedirectBindingURI"]
    ]
  }

  attribute_mapping = {
    email              = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    preferred_username = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    given_name         = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    middle_name        = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
  }
}

# SAML Identity Provider configuration with the Cognito user pool for the client Marvell
resource "aws_cognito_identity_provider" "saml_identity_provider_marvell" {
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  provider_name   = "Marvell"
  provider_type   = "SAML"
  idp_identifiers = ["marvell"]

  provider_details = {
    MetadataFile          = file("./metadata/marvell/Learnshipmetadata.xml")
    SLORedirectBindingURI = "ignored"
    SSORedirectBindingURI = "ignored"
    IDPSignout            = true
  }

  # SLORedirectBindingURI and SSORedirectBindingURI are populated from MetadataURL automatically.
  # This is done to avoid getting pending changes in terraform plan in each deployment.
  lifecycle {
    ignore_changes = [
      provider_details["SLORedirectBindingURI"],
      provider_details["SSORedirectBindingURI"]
    ]
  }

  attribute_mapping = {
    email              = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    preferred_username = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
    given_name         = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/givenname"
    middle_name        = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/surname"
  }
}

data "terraform_remote_state" "platform" {
  backend = "s3"

  config = {
    bucket = "learnship-terraform-states"
    key    = "${var.environment}/platform/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_route53_record" "cognito_sso" {
  zone_id = data.terraform_remote_state.platform.outputs.public_zone_id
  name    = local.name
  type    = "A"

  alias {
    zone_id                = "Z2FDTNDATAQYW2"
    name                   = aws_cognito_user_pool_domain.sso_domain.cloudfront_distribution_arn
    evaluate_target_health = false
  }
}
