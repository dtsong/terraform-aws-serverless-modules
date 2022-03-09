resource "aws_secretsmanager_secret" "service_secret" {
  name = var.name
}

resource "aws_secretsmanager_secret_version" "service_credentials" {
  secret_id     = aws_secretsmanager_secret.service_secret.id
  secret_string = <<EOF
{
  "db_username": "${var.db_username}",
  "db_password": "${var.db_password}",
  "client_api_key": "${var.client_api_key}"
}
EOF
}
