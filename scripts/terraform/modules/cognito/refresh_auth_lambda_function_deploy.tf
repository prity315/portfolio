data "archive_file" "refresh_auth" {
  type        = "zip"
  source_file = "../lambda/auth-svc/refreshAuth.js"
  output_path = "zipFiles/refreshAuth.zip"
}

resource "aws_lambda_function" "refresh_auth" {
  filename         = data.archive_file.refresh_auth.output_path
  function_name    = "${var.null_label_prefix}-refreshAuth"
  role             = aws_iam_role.lambda_role.arn //Role ARN that is attached to the user to access lambda console
  handler          = "refreshAuth.handler"        //refreshAuth is the lambda script file name which has handler method
  source_code_hash = data.archive_file.refresh_auth.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime
  tags             = var.null_label_tags
  timeout          = 30
  layers           = [aws_lambda_layer_version.auth_svc_lambda_layer.arn]

  environment {
    variables = {
      environment        = var.lambda_env
      aws_env            = var.environment
      auth_client_id     = aws_cognito_user_pool_client.app_client_auth_svc.id
      auth_client_secret = aws_cognito_user_pool_client.app_client_auth_svc.client_secret
    }
  }

}

resource "aws_lambda_permission" "apigw_refresh_auth_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.refresh_auth.function_name
  principal     = "apigateway.amazonaws.com"
}
