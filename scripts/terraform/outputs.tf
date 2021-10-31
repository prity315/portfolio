output "login_ui_client_id" {
  value       = module.cognito_user_pool.login_ui_client_id
  description = "provides the app client id (with no secret key) from the created user pool"
}

output "ge_home_client_id" {
  value       = module.cognito_user_pool.ge_home_client_id
  description = "provides the app client id (with secret key generated) from the created user pool"
}

output "ge_home_client_secret" {
  value       = module.cognito_user_pool.ge_home_client_secret
  description = "provides the client secret key for ge-home app-client"
}

output "ge_platform_client_id" {
  value       = module.cognito_user_pool.ge_platform_client_id
  description = "provides the app client id (with secret key generated) for ge-platform from the created user pool"
}

output "ge_platform_client_secret" {
  value       = module.cognito_user_pool.ge_platform_client_secret
  description = "provides the client secret key for ge-platform app-client"
}

output "app_domain" {
  value       = module.cognito_user_pool.app_domain
  description = "provides the domain name configured through the terraform script in cognito user pool"
}

output "cognito_user_pool_id" {
  value       = module.cognito_user_pool.cognito_user_pool_id
  description = "provides the cognito user pool id"
}

output "user_access_key" {
  value       = aws_iam_access_key.user_access_key.id
  description = "User's access key"
}

output "user_secret_access_key" {
  value       = aws_iam_access_key.user_access_key.secret
  description = "User's secret access key"
}

output "sso_login_svc_client_id" {
  value       = module.cognito_user_pool.sso_login_svc_client_id
  description = "provides the client id of the sso-login-svc app client"
}

output "sso_login_svc_client_secret" {
  value       = module.cognito_user_pool.sso_login_svc_client_secret
  description = "provides the client secret key for sso-login-svc app-client"
}

output "custom_app_domain" {
  value       = module.cognito_user_pool.custom_app_domain
  description = "provides the custom domain name configured through the terraform script in cognito user pool"
}

output "user_creation_sqs_name" {
  value       = module.cognito_user_pool.user_creation_sqs_name
  description = "provides the SQS queue name used for user creation"
}

output "auth_svc_client_id" {
  value       = module.cognito_user_pool.auth_svc_client_id
  description = "provides the app client id (with secret key generated) from the created user pool"
}

output "auth_svc_client_secret" {
  value       = module.cognito_user_pool.auth_svc_client_secret
  description = "provides the client secret key for auth_svc app-client"
}
