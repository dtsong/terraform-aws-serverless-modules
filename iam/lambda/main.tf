provider "aws" {
  region = var.region
}

data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    sid = "LambdaAssumeRolePolicy"

    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "lambda_invoke_rds_policy" {
  statement {
    sid = "LambdaInvokeRdsPolicy"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["rds-db:connect"]

    resources = [
      var.rds_instance_arn
    ]
  }
}

data "aws_iam_policy_document" "lambda_secrets_manager_policy" {
  statement {
    sid = "LambdaRetrieveSecret"

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }

    actions = ["secretsmanager:GetSecretValue"]

    resources = [
      var.secrets_manager_secret_arn
    ]
  }
}

# Combines the above two data IAM policy documents once they are constructed
# Source: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document#example-of-merging-source-documents
data "aws_iam_policy_document" "lambda_necessary_db_access" {
  source_policy_documents = [
    data.aws_iam_policy_document.lambda_secrets_manager_policy.json,
    data.aws_iam_policy_document.lambda_invoke_rds_policy.json
  ]
}

resource "aws_iam_role" "lambda-role" {
  name = "${var.name}-role"

  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json
}

resource "aws_iam_role_policy" "lambda-policy" {
  name = "${var.name}-policy"
  role = aws_iam_role.lambda-role.id

  policy = data.aws_iam_policy_document.lambda_necessary_db_access.json
}
