# /logout endpoint to log out & clear the cookies
resource "aws_api_gateway_resource" "logout" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  parent_id   = aws_api_gateway_rest_api.ls_backend.root_resource_id
  path_part   = "logout"
}

resource "aws_api_gateway_method" "logout_get" {
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  resource_id   = aws_api_gateway_resource.logout.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "logout_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ls_backend.id
  resource_id             = aws_api_gateway_resource.logout.id
  http_method             = aws_api_gateway_method.logout_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.logout.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
    EOF
  }

  depends_on = [aws_api_gateway_method.logout_get]
}

resource "aws_api_gateway_method_response" "logout_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.logout.id
  http_method = aws_api_gateway_method.logout_get.http_method
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

  depends_on = [aws_api_gateway_method.logout_get]

}

resource "aws_api_gateway_integration_response" "logout_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.logout.id
  http_method = aws_api_gateway_method.logout_get.http_method
  status_code = 200

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_method_response.logout_get_response_200,
    aws_api_gateway_integration.logout_get_integration
  ]
}

resource "aws_api_gateway_method" "logout_options" {
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  resource_id   = aws_api_gateway_resource.logout.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "logout_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ls_backend.id
  resource_id             = aws_api_gateway_resource.logout.id
  http_method             = aws_api_gateway_method.logout_options.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cors_support.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
    EOF
  }

  depends_on = [aws_api_gateway_method.logout_options]
}

resource "aws_api_gateway_method_response" "logout_options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.logout.id
  http_method = aws_api_gateway_method.logout_options.http_method
  status_code = "200"

  response_models = {
    "application/json" = "Empty"
  }

  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
    "method.response.header.Set-Cookie"                       = true
  }

  depends_on = [aws_api_gateway_method.logout_options]

}

resource "aws_api_gateway_integration_response" "logout_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.logout.id
  http_method = aws_api_gateway_method.logout_options.http_method
  status_code = 200

  depends_on = [
    aws_api_gateway_method_response.logout_options_response_200,
    aws_api_gateway_integration.logout_options_integration
  ]
}

resource "aws_api_gateway_method_settings" "logout_get_logs" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  stage_name  = var.environment
  method_path = "${aws_api_gateway_resource.logout.path_part}/${aws_api_gateway_method.logout_get.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }

  depends_on = [
    aws_api_gateway_deployment.ls_backend_deployment
  ]
}
