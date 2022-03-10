variable "region" {
  default = "us-west-2"
}

variable "function_name" {
  description = "A unique name for the Lambda Function"
  type        = string
  default     = ""
}

variable "handler" {
  description = "Lambda Function entrypoint in your code"
  type        = string
  default     = ""
}

variable "runtime" {
  description = "Lambda Function runtime"
  type        = string
  default     = ""
}

variable "source_path" {
  description = "Absolute path to a local file or directory containing the Lambda source code"
  type        = any # string | list(string | map(any))
  default     = null
}

variable "intra_subnets" {
  description = "VPC Intra-Subnets for the Lambda configuration"
  type        = list(string)
}

variable "lambda_security_group_id" {
  description = "Security Group ID specifically for this Lambda"
  type        = string
}
