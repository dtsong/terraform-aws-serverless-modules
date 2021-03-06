variable "region" {
  description = "Region where this IAM role for RDS Proxy resides"
  type        = string
}

variable "name" {
  description = "Name of the RDS Proxy for this IAM role"
  type        = string
}

variable "rds_secret_arn" {
  description = "ARN of RDS Secret in Secrets Manager"
  type        = string
  sensitive   = true
}

variable "rds_key_id" {
  description = "KMS Key ID to allow RDS Proxy to use for decrypting"
  type        = string
  default     = "alias/aws/secretsmanager"
  sensitive   = true
}