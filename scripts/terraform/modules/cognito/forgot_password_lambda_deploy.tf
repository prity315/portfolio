data "archive_file" "zip_forgot_password" {
  type        = "zip"
  source_file = "../lambda/auth-svc/forgotPassword.js"
  output_path = "zipFiles/forgotPassword.zip"
}

resource "aws_lambda_function" "forgot_password" {
  filename         = data.archive_file.zip_forgot_password.output_path
  function_name    = "${var.null_label_prefix}-forgotPassword"
  role             = aws_iam_role.lambda_role.arn
  handler          = "forgotPassword.handler"
  source_code_hash = data.archive_file.zip_forgot_password.output_base64sha256
  runtime          = "nodejs12.x"
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

resource "aws_lambda_permission" "forgot_password_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.forgot_password.function_name
  principal     = "apigateway.amazonaws.com"
}
