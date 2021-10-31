provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  assume_role {
    role_arn = var.role_arn
  }
}

locals {
  lambda_modify_cf_response_file_location = "zipFiles/modifyCloudFrontResponseLambda.zip"
}

data "archive_file" "modify_cloudfront_response" {
  type        = "zip"
  source_file = var.modify_cf_response_source_dir
  output_path = local.lambda_modify_cf_response_file_location
}

resource "aws_lambda_function" "modify_cf_response" {
  description      = "Add the custom headers in CloudFront response before forwarding it to client"
  provider         = aws.us-east-1
  filename         = data.archive_file.modify_cloudfront_response.output_path
  function_name    = "${var.null_label_prefix}-${var.modify_cf_response_lambda_name}"
  role             = aws_iam_role.lambda_role.arn       //Role ARN that is attached to the user to access lambda console
  handler          = "modifyCloudFrontResponse.handler" //modifyCloudFrontResponse is the lambda script file name which has handler method
  source_code_hash = data.archive_file.modify_cloudfront_response.output_base64sha256
  runtime          = "nodejs12.x" //lambda runtime
  publish          = true

  tags = var.null_label_tags
}

