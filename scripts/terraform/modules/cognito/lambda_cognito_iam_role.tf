resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.lambda_role.id

  policy = file("./iam-role/policies/lambda_policy.json")
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.null_label_prefix}-cognito-execute"
  assume_role_policy = file("./iam-role/policies/lambda_assume_policy.json")

  tags = var.null_label_tags
}
