module "aws_lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime

  source_path = var.source_path
}