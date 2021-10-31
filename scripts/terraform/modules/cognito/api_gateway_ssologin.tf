# /ssologin endpoint to set the cookie for example idToken, geAuth token etc..
resource "aws_api_gateway_resource" "ssologin" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  parent_id   = aws_api_gateway_rest_api.ls_backend.root_resource_id
  path_part   = "ssologin"
}

resource "aws_api_gateway_method" "ssologin_post" {
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  resource_id   = aws_api_gateway_resource.ssologin.id
  http_method   = "POST"
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
  request_parameters = {
    "method.request.path.proxy"           = true
    "method.request.header.authorization" = true
  }
}

# Cognito authorizer
resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = "CognitoUserPoolAuthorizer"
  type          = "COGNITO_USER_POOLS"
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  provider_arns = [aws_cognito_user_pool.user_pool.arn]
}

resource "aws_api_gateway_integration" "sso_post_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ls_backend.id
  resource_id             = aws_api_gateway_resource.ssologin.id
  http_method             = aws_api_gateway_method.ssologin_post.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ssologin_auth.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
    EOF
  }

  depends_on = [aws_api_gateway_method.ssologin_post]
}

resource "aws_api_gateway_method_response" "ssologin_post_response_200" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.ssologin.id
  http_method = aws_api_gateway_method.ssologin_post.http_method
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

  depends_on = [aws_api_gateway_method.ssologin_post]

}

resource "aws_api_gateway_integration_response" "ssologin_post_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.ssologin.id
  http_method = aws_api_gateway_method.ssologin_post.http_method
  status_code = 200

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_method_response.ssologin_post_response_200,
    aws_api_gateway_integration.sso_post_integration
  ]
}

resource "aws_api_gateway_method" "ssologin_options" {
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  resource_id   = aws_api_gateway_resource.ssologin.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sso_options_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ls_backend.id
  resource_id             = aws_api_gateway_resource.ssologin.id
  http_method             = aws_api_gateway_method.ssologin_options.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.cors_support.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
    EOF
  }

  depends_on = [aws_api_gateway_method.ssologin_options]
}

resource "aws_api_gateway_method_response" "ssologin_options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.ssologin.id
  http_method = aws_api_gateway_method.ssologin_options.http_method
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

  depends_on = [aws_api_gateway_method.ssologin_options]

}

resource "aws_api_gateway_integration_response" "ssologin_options_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.ssologin.id
  http_method = aws_api_gateway_method.ssologin_options.http_method
  status_code = 200

  depends_on = [
    aws_api_gateway_method_response.ssologin_options_response_200,
    aws_api_gateway_integration.sso_options_integration
  ]
}

resource "aws_api_gateway_method_settings" "ssologin_post_logs" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  stage_name  = var.environment
  method_path = "${aws_api_gateway_resource.ssologin.path_part}/${aws_api_gateway_method.ssologin_post.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }

  depends_on = [
    aws_api_gateway_deployment.ls_backend_deployment
  ]
}

resource "aws_api_gateway_method" "ssologin_get" {
  rest_api_id   = aws_api_gateway_rest_api.ls_backend.id
  resource_id   = aws_api_gateway_resource.ssologin.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "sso_get_integration" {
  rest_api_id             = aws_api_gateway_rest_api.ls_backend.id
  resource_id             = aws_api_gateway_resource.ssologin.id
  http_method             = aws_api_gateway_method.ssologin_get.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.ssologin_auth.invoke_arn

  request_templates = {
    "application/json" = <<EOF
    {"statusCode": 200}
    EOF
  }

  depends_on = [aws_api_gateway_method.ssologin_get]
}

resource "aws_api_gateway_method_response" "ssologin_get_response_200" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.ssologin.id
  http_method = aws_api_gateway_method.ssologin_get.http_method
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

  depends_on = [aws_api_gateway_method.ssologin_get]

}

resource "aws_api_gateway_integration_response" "ssologin_get_integration_response" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  resource_id = aws_api_gateway_resource.ssologin.id
  http_method = aws_api_gateway_method.ssologin_get.http_method
  status_code = 200

  response_templates = {
    "application/json" = ""
  }

  depends_on = [
    aws_api_gateway_method_response.ssologin_get_response_200,
    aws_api_gateway_integration.sso_get_integration
  ]
}

resource "aws_api_gateway_method_settings" "ssologin_get_logs" {
  rest_api_id = aws_api_gateway_rest_api.ls_backend.id
  stage_name  = var.environment
  method_path = "${aws_api_gateway_resource.ssologin.path_part}/${aws_api_gateway_method.ssologin_get.http_method}"

  settings {
    metrics_enabled = true
    logging_level   = "INFO"
  }

  depends_on = [
    aws_api_gateway_deployment.ls_backend_deployment
  ]
}

