variable "region" {
  description = "The relevant region for this IAM role"
  type        = string
}

variable "name" {
  description = "Name of the Lambda IAM role"
  type        = string
}

variable "secrets_manager_secret_arn" {
  description = "DB Secret ARN to be accessed by the Lambda"
  type        = string
  sensitive   = true
}

variable "rds_instance_arn" {
  description = "RDS instance ARN to be accessed by the Lambda"
  type        = string
}
