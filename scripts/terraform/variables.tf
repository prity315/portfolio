variable "aws_region" {
  default     = "eu-central-1"
  description = "AWS region for the account used"
}

variable "environment" {

}

variable "role_arn" {

}

variable "cognito_user_pool_name" {
  default     = "users-pool"
  description = "AWS cognito user pool name"
}

variable "name_prefix" {

}

variable "lambda_env" {
  description = "Based on the value like test, stage or prod, the respective Platform API would be called from user migration lambda function"
}

variable "user_name" {
  description = "Creates user for different different environment like test,stage,prod etc.."
}

variable "callback_url" {

}

variable "sign_out_url" {

}

variable "metadata_url" {
  description = "Set the Provider metadata URL"
}

