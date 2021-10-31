#Note: If the lambda function is placed in AWS S3, we need to pass the S3 resource details
#here to read the lambda from S3.

locals {
  lambda_create_auth_file_location = "zipFiles/createAuthChallengeLambda.zip"
}

data "archive_file" "create_auth_challenge" {
  type        = "zip"
  source_file = var.create_auth_source_dir //This works if only 1 lambda script file  is there.
  output_path = local.lambda_create_auth_file_location
}

resource "aws_lambda_function" "create_auth_challenge" {
  filename         = data.archive_file.create_auth_challenge.output_path
  function_name    = var.environment == "production" || var.environment == "staging" ? "${var.null_label_prefix}-${var.create_auth_lambda_name}" : "${var.null_label_prefix}-createAuth"
  role             = aws_iam_role.lambda_role.arn  //Role ARN that is attached to the user to access lambda console
  handler          = "createAuthChallenge.handler" //createAuthChallenge is the lambda script file name which has handler method
  source_code_hash = data.archive_file.create_auth_challenge.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime

  tags = var.null_label_tags
}

#Creates a Lambda permission to allow Cognito invoking the Lambda function
resource "aws_lambda_permission" "create_auth_lambda_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.create_auth_challenge.function_name
  principal     = "cognito-idp.amazonaws.com"
}
