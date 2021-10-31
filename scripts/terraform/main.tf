provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn = var.role_arn
  }
}

module "cognito_user_pool" {
  source = "./modules/cognito"

  environment            = var.environment
  cognito_user_pool_name = var.cognito_user_pool_name
  name_prefix            = var.name_prefix
  lambda_env             = var.lambda_env
  null_label_prefix      = module.sso_login_backend_label.id
  null_label_tags        = module.sso_login_backend_label.tags
  callback_url           = var.callback_url
  sign_out_url           = var.sign_out_url
  metadata_url           = var.metadata_url
}

module "sso_login_backend_label" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.12.2"
  namespace   = "globalenglish"
  environment = var.environment
  stage       = var.name_prefix
  name        = "sso-login-backend"

  tags = {
    Service     = "sso-login-backend"
    Terraformed = true
  }
}

terraform {
  backend "s3" {
    bucket         = "learnship-terraform-states"
    dynamodb_table = "learnship-terraform-state-lock"
    encrypt        = true
    region         = "eu-central-1"
  }
}

locals {
  name = "${var.name_prefix != "" ? "${var.name_prefix}-" : ""}sso-login-backend"
}

data "terraform_remote_state" "platform" {
  backend = "s3"

  config = {
    bucket = "learnship-terraform-states"
    key    = "${var.environment}/platform/terraform.tfstate"
    region = "eu-central-1"
  }
}

resource "aws_cloudwatch_metric_alarm" "user_creation_dqueue_errors" {
  alarm_name          = "${module.sso_login_backend_label.id}-user-creation-lambda-sqs-errors"
  alarm_description   = "Monitor exceptions or errors in user creation sqs"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "NumberOfMessagesReceived"
  namespace           = "sso-login-backend"
  period              = "60"
  statistic           = "Sum"
  threshold           = 2
  treat_missing_data  = "missing"
  ok_actions          = [data.terraform_remote_state.platform.outputs.sns_alert_topic_arn]
  alarm_actions       = [data.terraform_remote_state.platform.outputs.sns_alert_topic_arn]
  tags                = module.sso_login_backend_label.tags

  dimensions = {
    QueueName = "${module.cognito_user_pool.user_creation_sqs_name}"
  }
}



resource "aws_cloudwatch_log_metric_filter" "user_mig_lambda_error_count" {
  name           = "${local.name}-UserMigLambdaErrorCount"
  pattern        = "{ ($.errorMessage = \"[object Object]\")}"
  log_group_name = "/aws/lambda/${module.sso_login_backend_label.id}-userMigration"

  metric_transformation {
    name      = "${local.name}-UserMigLambdaErrorCount"
    namespace = "sso-login-backend"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "no_of_errors_in_user_mig_lambda_logs" {
  alarm_name          = "${module.sso_login_backend_label.id}-user-mig-lambda-log-errors"
  alarm_description   = "Monitor exceptions or errors in userMigration lambda"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.user_mig_lambda_error_count.name
  namespace           = "sso-login-backend"
  period              = "300"
  statistic           = "Sum"
  threshold           = 5
  treat_missing_data  = "missing"
  ok_actions          = [data.terraform_remote_state.platform.outputs.sns_alert_topic_arn]
  alarm_actions       = [data.terraform_remote_state.platform.outputs.sns_alert_topic_arn]
  tags                = module.sso_login_backend_label.tags
}
