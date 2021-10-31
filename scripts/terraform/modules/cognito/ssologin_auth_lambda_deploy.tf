data "archive_file" "ssologin_auth" {
  type        = "zip"
  source_file = "../lambda/auth-svc/ssoLoginAuth.js"
  output_path = "zipFiles/ssoLoginAuth.zip"
}

resource "aws_lambda_function" "ssologin_auth" {
  filename         = data.archive_file.ssologin_auth.output_path
  function_name    = "${var.null_label_prefix}-ssoLoginAuth"
  role             = aws_iam_role.lambda_role.arn //Role ARN that is attached to the user to access lambda console
  handler          = "ssoLoginAuth.handler"       //ssoLoginAuth is the lambda script file name which has handler method
  source_code_hash = data.archive_file.ssologin_auth.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime
  tags             = var.null_label_tags
  timeout          = 30
  layers           = [aws_lambda_layer_version.auth_svc_lambda_layer.arn]

  environment {
    variables = {
      environment = var.lambda_env
      aws_env     = var.environment
    }
  }

}

resource "aws_lambda_permission" "apigw_ssologin_auth_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ssologin_auth.function_name
  principal     = "apigateway.amazonaws.com"
}
