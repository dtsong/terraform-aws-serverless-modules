variable "region" {
  description = "The relevant region for this IAM role"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of Lambda Function that is to be invoked by the API Gateway"
  type        = string
}