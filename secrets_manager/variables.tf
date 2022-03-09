variable "name" {
  description = "Name of the secret"
  type        = string
}

variable "db_username" {
  description = "DB Username to put into Secrets Manager"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "DB Password to put into Secrets Manager"
  type        = string
  sensitive   = true
}

variable "client_api_key" {
  description = "Client API Key to be put into Secrets Manager"
  type        = string
  sensitive   = true
}