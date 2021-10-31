data "archive_file" "zip_user_creation_lambda" {
  type        = "zip"
  source_file = "../lambda/user-creation/userCreation.js"
  output_path = "zipFiles/userCreationLambda.zip"
}

resource "aws_lambda_function" "user_creation" {
  filename         = data.archive_file.zip_user_creation_lambda.output_path
  function_name    = "${var.null_label_prefix}-userCreation"
  role             = aws_iam_role.lambda_role.arn
  handler          = "userCreation.handler"
  source_code_hash = data.archive_file.zip_user_creation_lambda.output_base64sha256
  runtime          = "nodejs12.x"

  environment {
    variables = {
      environment  = var.lambda_env
      user_pool_id = aws_cognito_user_pool.user_pool.id
    }
  }

  tags = var.null_label_tags
}

resource "aws_lambda_permission" "user_creation_lambda_permission" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_creation.function_name
  principal     = "sqs.amazonaws.com"
}
