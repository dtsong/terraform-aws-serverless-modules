module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4.0"

  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

  tags = var.tags
}
