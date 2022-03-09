provider "aws" {
  region = var.region
}


resource "aws_api_gateway_rest_api" "api_gateway" {
  name = var.function_name
}

resource "aws_api_gateway_stage" "gateway_stage" {
  stage_name            = var.stage_name
  rest_api_id           = aws_api_gateway_rest_api.api_gateway.id
  deployment_id         = aws_api_gateway_deployment.gateway_deploy.id
  cache_cluster_enabled = var.cache_enabled
  cache_cluster_size    = var.cache_cluster_size

  tags = {
    Resource = "api_gateway"
    Owner    = "dtsong"
  }

  depends_on = [aws_api_gateway_deployment.gateway_deploy]
}

resource "aws_api_gateway_deployment" "gateway_deploy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = ""

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromApiGateway"
  action        = "lambda:InvokeFunction"
  function_name = var.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_deployment.gateway_deploy.execution_arn}*"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_api_gateway_stage.gateway_stage]
}

resource "aws_api_gateway_method_settings" "aws_api_gateway_cache_enabled" {
  count       = var.cache_enabled == "false" ? 0 : 1
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = var.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"
  }

  depends_on = [aws_api_gateway_stage.gateway_stage]
}

resource "aws_api_gateway_method_settings" "aws_api_gateway_default" {
  count       = var.cache_enabled == "true" ? 0 : 1
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name  = var.stage_name
  method_path = "*/*"

  settings {
    metrics_enabled    = true
    data_trace_enabled = true
    logging_level      = "INFO"
  }

  depends_on = [aws_api_gateway_stage.gateway_stage]
}
