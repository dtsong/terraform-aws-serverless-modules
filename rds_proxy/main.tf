resource "aws_db_proxy_default_target_group" "rds_proxy_target_group" {
  db_proxy_name = aws_db_proxy.db_proxy.name

  connection_pool_config {
    connection_borrow_timeout = 120
    max_connections_percent   = 100
  }
}

resource "aws_db_proxy_target" "rds_proxy_target" {
  db_instance_identifier = var.rds_db_identifier
  db_proxy_name          = aws_db_proxy.db_proxy.name
  target_group_name      = aws_db_proxy_default_target_group.rds_proxy_target_group.name
}

resource "aws_db_proxy" "db_proxy" {
  name = var.name

  debug_logging          = false
  engine_family          = "POSTGRESQL"
  idle_client_timeout    = 1800
  require_tls            = true
  role_arn               = var.rds_proxy_iam_role_arn
  vpc_security_group_ids = [var.rds_proxy_security_group_id]
  vpc_subnet_ids         = var.vpc_database_subnets

  auth {
    auth_scheme = "SECRETS"
    iam_auth    = "REQUIRED"
    secret_arn  = var.rds_secret_arn
  }
}