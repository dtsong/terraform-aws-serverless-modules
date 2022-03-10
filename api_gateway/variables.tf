variable "region" {
  description = "The AWS region to deploy this API Gateway"
  type        = string
}

variable "function_name" {
  description = "The Lambda function name to be attached to this API Gateway"
  type        = string
}

variable "lambda_invoke_arn" {
  description = "Lambda ARN to be invoked by this API Gateway"
  type        = string
}

variable "stage_name" {
  description = "The stage for the API Gateway"
  type        = string
  default     = "api"
}

variable "cache_enabled" {
  description = "Set true/false to enable API Gateway caching"
  type        = bool
  default     = true
}

variable "cache_encrypted" {
  description = "Set true/false to enable API Gateway cache encryption"
  type        = bool
  default     = true
}

variable "cache_cluster_size" {
  description = "The size of the cache cluster for the stage, if enabled. Allowed values include 0.5, 1.6, 6.1, 13.5, 28.4, 58.2, 118 and 237"
  type        = number
  default     = 0.5
}

variable "tags" {
  description = "A map of tags to assign to resources."
  type        = map(string)
  default     = {}
}

variable "api_gateway_security_policy" {
  default = "TLS_1_2"
}
