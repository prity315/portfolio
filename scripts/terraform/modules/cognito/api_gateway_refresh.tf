# /refresh endpoint to get the idToken with the given refresh token from Cognito
resource "aws_api_gateway_resource" "refresh" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  parent_id   = aws_api_gateway_rest_api.ls_backend.root_resource_id
  path_part   = "refresh"
}

resource "aws_api_gateway_request_validator" "refresh_param" {
  name                        = "Validate query string parameters and headers"
  rest_api_id                 = aws_api_gateway_rest_api.ls_backend.id
  validate_request_body       = false
  validate_request_parameters = true
}

resource "aws_api_gateway_method" "refresh_get" {
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  resource_id   = aws_api_gateway_resource.refresh.id
  http_method   = "GET"
  authorization = "NONE"

  request_parameters = {
    "method.request.querystring.token" = true
  }
  request_validator_id = aws_api_gateway_request_validator.refresh_param.id
}

resource "aws_api_gateway_integration" "refresh_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ls_backend.id
  resource_id             = aws_api_gateway_resource.refresh.id
  http_method             = aws_api_gateway_method.refresh_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.refresh_auth.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
    EOF
  }

  depends_on = [aws_api_gateway_method.refresh_get]
}

resource "aws_api_gateway_method_response" "refresh_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.refresh.id
  http_method = aws_api_gateway_method.refresh_get.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }

  depends_on = [aws_api_gateway_method.refresh_get]

}

resource "aws_api_gateway_integration_response" "refresh_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.refresh.id
  http_method = aws_api_gateway_method.refresh_get.http_method
  status_code = 200

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_method_response.refresh_get_response_200,
    aws_api_gateway_integration.refresh_get_integration
  ]
}

resource "aws_api_gateway_method_settings" "refresh_get_logs" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  stage_name  = var.environment
  method_path = "${aws_api_gateway_resource.refresh.path_part}/${aws_api_gateway_method.refresh_get.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }

  depends_on = [
    aws_api_gateway_deployment.ls_backend_deployment
  ]
}
