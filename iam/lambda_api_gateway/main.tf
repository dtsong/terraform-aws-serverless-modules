provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    sid = "LambdaAssumeRolePolicy"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["apigateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "lambda_api_gateway" {
  name = "${var.name}role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "invoke_lambda" {
  name = "${var.name}-policy"
  role = aws_iam_role.lambda_api_gateway.id

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          "Effect" : "Allow",
          "Action" : "lambda:InvokeFunction",
          "Resource" : var.lambda_function_arn
        }
      ]
    }
  )
}