provider "aws" {
  region = var.region
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  name = var.function_name

  tags = var.tags
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.proxy.id

  http_method   = "ANY"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"

  uri = var.lambda_invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  resource_id   = aws_api_gateway_rest_api.api_gateway.root_resource_id

  http_method   = "GET"
  authorization = "AWS_IAM"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id             = aws_api_gateway_rest_api.api_gateway.id
  resource_id             = aws_api_gateway_method.proxy_root.resource_id
  http_method             = aws_api_gateway_method.proxy_root.http_method
  integration_http_method = "POST"

  type                    = "AWS_PROXY"
  uri                     = var.lambda_invoke_arn
}

resource "aws_api_gateway_deployment" "gateway_deploy" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = "test"
}

resource "aws_lambda_permission" "api_gateway_invoke_lambda" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"

  # The "/*/*" portion grants access from any method on any resource
  # within the API Gateway REST API.
  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
}

// resource "aws_api_gateway_stage" "gateway_stage" {
//   stage_name            = var.stage_name
//   rest_api_id           = aws_api_gateway_rest_api.api_gateway.id
//   deployment_id         = aws_api_gateway_deployment.gateway_deploy.id
//   cache_cluster_enabled = var.cache_enabled
//   cache_cluster_size    = var.cache_cluster_size

//   tags = {
//     Resource = "api_gateway"
//     Owner    = "dtsong"
//   }

//   depends_on = [aws_api_gateway_deployment.gateway_deploy]
// }

// resource "aws_api_gateway_deployment" "gateway_deploy" {
//   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
//   stage_name  = ""


//   lifecycle {
//     create_before_destroy = true
//   }
// }

// resource "aws_lambda_permission" "lambda_permission" {
//   statement_id  = "AllowExecutionFromApiGateway"
//   action        = "lambda:InvokeFunction"
//   function_name = var.function_name
//   principal     = "apigateway.amazonaws.com"
//   source_arn    = "${aws_api_gateway_deployment.gateway_deploy.execution_arn}*"

//   lifecycle {
//     create_before_destroy = true
//   }

//   depends_on = [aws_api_gateway_stage.gateway_stage]
// }

// resource "aws_api_gateway_method_settings" "aws_api_gateway_cache_enabled" {
//   count       = var.cache_enabled == "false" ? 0 : 1
//   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
//   stage_name  = var.stage_name
//   method_path = "*/*"

//   settings {
//     metrics_enabled    = true
//     data_trace_enabled = true
//     logging_level      = "INFO"
//   }

//   depends_on = [aws_api_gateway_stage.gateway_stage]
// }

// resource "aws_api_gateway_method_settings" "aws_api_gateway_default" {
//   count       = var.cache_enabled == "true" ? 0 : 1
//   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
//   stage_name  = var.stage_name
//   method_path = "*/*"

//   settings {
//     metrics_enabled    = true
//     data_trace_enabled = true
//     logging_level      = "INFO"
//   }

//   depends_on = [aws_api_gateway_stage.gateway_stage]
// }
