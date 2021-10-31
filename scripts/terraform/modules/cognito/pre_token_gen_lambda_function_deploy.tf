locals {
  lambda_pre_token_gen_file_location = "zipFiles/preTokenGenerationLambda.zip"
}

data "archive_file" "pre_token_generation" {
  type        = "zip"
  source_file = var.pre_token_gen_source_dir
  output_path = local.lambda_pre_token_gen_file_location
}

resource "aws_lambda_function" "pre_token_generation" {
  filename         = data.archive_file.pre_token_generation.output_path
  function_name    = "${var.null_label_prefix}-${var.pre_token_gen_lambda_name}"
  role             = aws_iam_role.lambda_role.arn //Role ARN that is attached to the user to access lambda console
  handler          = "preTokenGen.handler"        //preTokenGen is the lambda script file name which has handler method
  source_code_hash = data.archive_file.pre_token_generation.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime

  tags = var.null_label_tags
}

#Creates a Lambda permission to allow Cognito invoking the Lambda function
resource "aws_lambda_permission" "pre_token_generation_lambda_permission" {
  statement_id  = "AllowExecutionFromCognito"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.pre_token_generation.function_name
  principal     = "cognito-idp.amazonaws.com"
}
