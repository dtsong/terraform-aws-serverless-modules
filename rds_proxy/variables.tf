variable "name" {
  description = "Name for the RDS Proxy"
  type        = string
}

variable "engine_family" {
  description = "Engine family for RDS Proxy; only supports POSTGRESQL and MYSQL"
  type        = string
  default     = "POSTGRESQL"
}

variable "rds_db_identifier" {
  description = "RDS DB Identifier to be associated with RDS Proxy"
  type        = string
}

variable "rds_proxy_iam_role_arn" {
  description = "IAM Role ARN for the RDS Proxy"
  type        = string
}

variable "rds_proxy_security_group_id" {
  description = "Security Group ID for the RDS Proxy"
  type        = string
}

variable "vpc_database_subnets" {
  description = "VPC Database Subnets for the RDS Proxy"
  type        = map(string)
}

variable "rds_secret_arn" {
  description = "Secrets Manager ARN for RDS Proxy access to DB"
  type        = string
}
