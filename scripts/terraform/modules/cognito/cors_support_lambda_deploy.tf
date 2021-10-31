data "archive_file" "cors_support" {
  type        = "zip"
  source_file = "../lambda/auth-svc/corsSupport.js"
  output_path = "zipFiles/corsSupport.zip"
}

resource "aws_lambda_function" "cors_support" {
  filename         = data.archive_file.cors_support.output_path
  function_name    = "${var.null_label_prefix}-corsSupport"
  role             = aws_iam_role.lambda_role.arn //Role ARN that is attached to the user to access lambda console
  handler          = "corsSupport.handler"
  source_code_hash = data.archive_file.cors_support.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime
  timeout          = 30
  layers           = [aws_lambda_layer_version.auth_svc_lambda_layer.arn]
  tags             = var.null_label_tags
}

resource "aws_lambda_permission" "apigw_cors_support_lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.cors_support.function_name
  principal     = "apigateway.amazonaws.com"
}
