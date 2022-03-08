module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.cidr

  azs              = ["${var.region}a", "${var.region}b", "${var.region}c"]
  private_subnets  = var.private_subnets
  database_subnets = var.database_subnets

  create_database_subnet_group = var.create_database_subnet_group

  # VPC Flow Logs (Cloudwatch log group and IAM role will be created)
  enable_flow_log                      = true
  create_flow_log_cloudwatch_log_group = true
  create_flow_log_cloudwatch_iam_role  = true
  flow_log_max_aggregation_interval    = 60
}
