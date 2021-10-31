#Note: If the lambda function is placed in AWS S3, we need to pass the S3 resource details
#here to read the lambda from S3.

locals {
  lambda_verify_auth_file_location = "zipFiles/verifyAuthChallengeLambda.zip"
}

data "archive_file" "verify_auth_challenge" {
  type        = "zip"
  source_file = var.verify_auth_source_dir //This works if only 1 lambda script file  is there.
  output_path = local.lambda_verify_auth_file_location
}

resource "aws_lambda_function" "verify_auth_challenge" {
  filename         = data.archive_file.verify_auth_challenge.output_path
  function_name    = var.environment == "production" || var.environment == "staging" ? "${var.null_label_prefix}-${var.verify_auth_lambda_name}" : "${var.null_label_prefix}-verifyAuth"
  role             = aws_iam_role.lambda_role.arn  //Role ARN that is attached to the user to access lambda console
  handler          = "verifyAuthChallenge.handler" //verifyAuthChallenge is the lambda script file name which has handler method
  source_code_hash = data.archive_file.verify_auth_challenge.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime

  tags = var.null_label_tags
}

#Creates a Lambda permission to allow Cognito invoking the Lambda function
resource "aws_lambda_permission" "verify_auth_lambda_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.verify_auth_challenge.function_name
  principal     = "cognito-idp.amazonaws.com"
}
