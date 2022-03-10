module "aws_lambda_function" {
  source = "terraform-aws-modules/lambda/aws"

  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime

  source_path = var.source_path

  # Networking
  vpc_subnet_ids         = var.intra_subnets
  vpc_security_group_ids = [var.lambda_security_group_id]
}