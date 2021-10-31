output "login_ui_client_id" {
  value       = aws_cognito_user_pool_client.app-client.id
  description = "provides the app client id (with no secret key) from the created user pool"
}

output "ge_home_client_id" {
  value       = aws_cognito_user_pool_client.app-client-ge-home.id
  description = "provides the app client id (with secret key generated) from the created user pool"
}

output "ge_home_client_secret" {
  value       = aws_cognito_user_pool_client.app-client-ge-home.client_secret
  description = "provides the client secret key for ge-home app-client"
}

output "ge_platform_client_id" {
  value       = aws_cognito_user_pool_client.app-client-ge-platform.id
  description = "provides the app client id (with secret key generated) for ge-platform from the created user pool"
}

output "ge_platform_client_secret" {
  value       = aws_cognito_user_pool_client.app-client-ge-platform.client_secret
  description = "provides the client secret key for ge-platform app-client"
}

output "sso_login_svc_client_id" {
  value       = aws_cognito_user_pool_client.app_client_sso.id
  description = "provides the client id of the sso-login-svc app client"
}

output "sso_login_svc_client_secret" {
  value       = aws_cognito_user_pool_client.app_client_sso.client_secret
  description = "provides the client secret key for sso-login-svc app-client"
}

output "app_domain" {
  value       = aws_cognito_user_pool_domain.domain.id
  description = "provides the domain name configured through the terraform script in cognito user pool"
}

output "custom_app_domain" {
  value       = aws_cognito_user_pool_domain.sso_domain.id
  description = "provides the custom domain name configured through the terraform script in cognito user pool"
}

output "cognito_user_pool_id" {
  value       = aws_cognito_user_pool.user_pool.id
  description = "provides the cognito user pool id"
}

output "user_creation_sqs_name" {
  value       = aws_sqs_queue.user_creation_queue.name
  description = "provides the SQS queue name used for user creation"
}

output "auth_svc_client_id" {
  value       = aws_cognito_user_pool_client.app_client_auth_svc.id
  description = "provides the app client id (with secret key generated) from the created user pool"
}

output "auth_svc_client_secret" {
  value       = aws_cognito_user_pool_client.app_client_auth_svc.client_secret
  description = "provides the client secret key for auth-svc app-client"
}
