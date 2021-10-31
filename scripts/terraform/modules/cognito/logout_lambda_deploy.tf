data "archive_file" "logout" {
  type        = "zip"
  source_file = "../lambda/auth-svc/logout.js"
  output_path = "zipFiles/logout.zip"
}

resource "aws_lambda_function" "logout" {
  filename         = data.archive_file.logout.output_path
  function_name    = "${var.null_label_prefix}-logout"
  role             = aws_iam_role.lambda_role.arn //Role ARN that is attached to the user to access lambda console
  handler          = "logout.handler"             //logout is the lambda script file name which has handler method
  source_code_hash = data.archive_file.logout.output_base64sha256
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

resource "aws_lambda_permission" "apigw_logout_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.logout.function_name
  principal     = "apigateway.amazonaws.com"
}
