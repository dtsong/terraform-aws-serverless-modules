data "aws_iam_policy_document" "assume_role_policy" {
  statement {
      sid = "1"

      actions = [
        "sts:AssumeRole"
      ]

      resources = [
        var.api_caller_role_arn
      ]
  }
}

data "aws_iam_policy_document" "lambda_policy" {
  statement {
      
  }
}

resource "aws_iam_role" "lambda-role" {
  name = "${var.name}-role"

  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}

resource "aws_iam_role_policy" "lambda-policy" {
  name = "${var.name}-policy"
  role = aws_iam_role.lambda-role.id

  policy = data.aws_iam_policy_document.assume_role_policy.json
}
