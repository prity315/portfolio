locals {
  lambda_zip_file_location = "zipFiles/userMigrationLambda.zip"
}

data "archive_file" "zip_user_migration_lambda" {
  type        = "zip"
  source_dir  = var.user_migration_source_dir
  output_path = local.lambda_zip_file_location
}

resource "aws_cloudwatch_log_group" "user_migration_lambda" {
  name              = "/aws/lambda/${var.null_label_prefix}-userMigration"
  retention_in_days = 30
}

resource "aws_lambda_function" "user_migration" {
  filename         = data.archive_file.zip_user_migration_lambda.output_path
  function_name    = "${var.null_label_prefix}-${var.user_migration_lambda_name}"
  role             = aws_iam_role.lambda_role.arn
  handler          = "userMigration.handler"
  source_code_hash = data.archive_file.zip_user_migration_lambda.output_base64sha256
  runtime          = "nodejs12.x"
  timeout          = 30

  vpc_config {
    security_group_ids = [aws_security_group.allow_lambda.id]
    subnet_ids         = data.terraform_remote_state.platform.outputs.private_subnet_ids
  }

  environment {
    variables = {
      environment = var.lambda_env
    }
  }

  depends_on = [
    aws_iam_role_policy.lambda_policy,
    aws_cloudwatch_log_group.user_migration_lambda
  ]

  tags = var.null_label_tags
}

#Creates a Lambda permission to allow Cognito invoking the Lambda function
resource "aws_lambda_permission" "user_mig_lambda_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.user_migration.function_name
  principal     = "cognito-idp.amazonaws.com"
}
