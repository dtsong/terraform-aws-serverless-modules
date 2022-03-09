variable "region" {}
variable "account_id" {}
variable "function_name" {}

variable "lambda_invoke_arn" {
  description = "Lambda ARN to be invoked by this API Gateway"
  type        = string
}

variable "certificate_arn" {
  default = "NOTSET"
}

variable "stage_name" {
  default = "api"
}

variable "cache_enabled" {
  default = "false"
}

variable "cache_encrypted" {
  default = "false"
}

variable "cache_ttl_in_seconds" {
  default = 120
}

variable "cache_cluster_size" {
  default = "0.5"
}

variable "api_gateway_endpoint_configuration_types" {
  default = ["REGIONAL"]
}

variable "api_gateway_security_policy" {
  default = "TLS_1_2"
}
