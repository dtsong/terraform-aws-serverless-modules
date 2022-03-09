output "id" {
  value = aws_secretsmanager_secret.service_secret.id
}

output "arn" {
  value = aws_secretsmanager_secret.service_secret.arn
}
