variable "cognito_user_pool_name" {
  default     = "users-pool"
  description = "AWS cognito user pool name"
}

variable "environment" {
  description = "Name of the environment, e.g. production, staging or dynamic"
}

variable "callback_url" {

}

variable "sign_out_url" {

}

variable "auth_flows_for_login_ui" {
  type        = list
  default     = ["ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  description = "Auth Flows Configuration"
}

variable "auth_flows_for_ge_home" {
  type        = list
  default     = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]
  description = "Auth Flows Configuration"
}

variable "auth_flows_refresh_token" {
  type        = list
  default     = ["ALLOW_REFRESH_TOKEN_AUTH"]
  description = "Auth Flows Configuration"
}

variable "supported_idp" {
  type        = list
  default     = ["COGNITO"]
  description = "List of supported Identity Providers"
}

variable "oauth_flows" {
  type        = list
  default     = ["implicit"]
  description = "List of allowed OAuth flows"
}

variable "oauth_scopes" {
  type        = list
  default     = ["email", "openid", "profile"]
  description = "List of allowed OAuth scopes"
}

variable "domain" {
  default = "login-service"
}

variable "user_migration_source_dir" {
  default     = "../lambda/user-migration"
  description = "File location of the lambda script"
}

variable "user_migration_lambda_name" {
  default = "userMigration"
}

variable "define_auth_source_dir" {
  default = "../lambda/custom-auth-lambda/defineAuthChallenge.js"
}

variable "define_auth_lambda_name" {
  default = "defineAuthChallenge"
}

variable "create_auth_source_dir" {
  default = "../lambda/custom-auth-lambda/createAuthChallenge.js"
}

variable "create_auth_lambda_name" {
  default = "createAuthChallenge"
}

variable "verify_auth_source_dir" {
  default = "../lambda/custom-auth-lambda/verifyAuthChallenge.js"
}

variable "verify_auth_lambda_name" {
  default = "verifyAuthChallenge"
}

variable "pre_token_gen_source_dir" {
  default     = "../lambda/pre-token-generation/preTokenGen.js"
  description = "File location of the lambda script"
}

variable "pre_token_gen_lambda_name" {
  default = "preTokenGeneration"
}

variable "name_prefix" {

}

variable "lambda_env" {
  description = "Based on the value like test, stage or prod, the respective Platform API would be called from user migration lambda function"
}

variable "null_label_prefix" {

}

variable "null_label_tags" {

}

variable "oauth_flows_sso_client" {
  type        = list
  default     = ["code"]
  description = "List of allowed OAuth flows"
}

variable "metadata_url" {
  description = "Set the Provider metadata URL"
}
