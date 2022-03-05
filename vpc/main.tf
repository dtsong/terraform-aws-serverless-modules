locals {
  max_subnet_length = max(
    length(var.database_subnets),
  )

  vpc_id = try(aws_vpc.this[0].id, "")
}

################################################################################
# VPC
################################################################################

resource "aws_vpc" "this" {
  count = var.create_vpc ? 1 : 0

  cidr_block = var.cidr

  tags = merge(
    { "Name" = var.name }
  )
}

################################################################################
# Database subnet
################################################################################

resource "aws_subnet" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 ? length(var.database_subnets) : 0

  vpc_id            = local.vpc_id
  cidr_block        = var.database_subnets[count.index]
  availability_zone = length(regexall("^[a-z]{2}-", element(var.azs, count.index))) > 0 ? element(var.azs, count.index) : null

  tags = merge(
    {
      "Name" = format(
        "${var.name}-${var.database_subnet_suffix}-%s",
        element(var.azs, count.index),
      )
    },
    var.tags,
    var.database_subnet_tags,
  )
}

resource "aws_db_subnet_group" "database" {
  count = var.create_vpc && length(var.database_subnets) > 0 && var.create_database_subnet_group ? 1 : 0

  name        = lower(coalesce(var.database_subnet_group_name, var.name))
  description = "Database subnet group for ${var.name}"
  subnet_ids  = aws_subnet.database[*].id

  tags = merge(
    {
      "Name" = lower(coalesce(var.database_subnet_group_name, var.name))
    },
    var.tags,
    var.database_subnet_group_tags,
  )
}

// ################################################################################
// # Database routes
// ################################################################################

// resource "aws_route_table" "database" {
//   count = var.create_vpc && var.create_database_subnet_route_table && length(var.database_subnets) > 0 ? var.single_nat_gateway || var.create_database_internet_gateway_route ? 1 : length(var.database_subnets) : 0

//   vpc_id = local.vpc_id

//   tags = merge(
//     {
//       "Name" = var.single_nat_gateway || var.create_database_internet_gateway_route ? "${var.name}-${var.database_subnet_suffix}" : format(
//         "${var.name}-${var.database_subnet_suffix}-%s",
//         element(var.azs, count.index),
//       )
//     },
//     var.tags,
//     var.database_route_table_tags,
//   )
// }

// resource "aws_route" "database_internet_gateway" {
//   count = var.create_vpc && var.create_igw && var.create_database_subnet_route_table && length(var.database_subnets) > 0 && var.create_database_internet_gateway_route && false == var.create_database_nat_gateway_route ? 1 : 0

//   route_table_id         = aws_route_table.database[0].id
//   destination_cidr_block = "0.0.0.0/0"
//   gateway_id             = aws_internet_gateway.this[0].id

//   timeouts {
//     create = "5m"
//   }
// }

// resource "aws_route" "database_nat_gateway" {
//   count = var.create_vpc && var.create_database_subnet_route_table && length(var.database_subnets) > 0 && false == var.create_database_internet_gateway_route && var.create_database_nat_gateway_route && var.enable_nat_gateway ? var.single_nat_gateway ? 1 : length(var.database_subnets) : 0

//   route_table_id         = element(aws_route_table.database[*].id, count.index)
//   destination_cidr_block = "0.0.0.0/0"
//   nat_gateway_id         = element(aws_nat_gateway.this[*].id, count.index)

//   timeouts {
//     create = "5m"
//   }
// }

// ################################################################################
// # Database Network ACLs
// ################################################################################

// resource "aws_network_acl" "database" {
//   count = var.create_vpc && var.database_dedicated_network_acl && length(var.database_subnets) > 0 ? 1 : 0

//   vpc_id     = local.vpc_id
//   subnet_ids = aws_subnet.database[*].id

//   tags = merge(
//     { "Name" = "${var.name}-${var.database_subnet_suffix}" },
//     var.tags,
//     var.database_acl_tags,
//   )
// }

// resource "aws_network_acl_rule" "database_inbound" {
//   count = var.create_vpc && var.database_dedicated_network_acl && length(var.database_subnets) > 0 ? length(var.database_inbound_acl_rules) : 0

//   network_acl_id = aws_network_acl.database[0].id

//   egress          = false
//   rule_number     = var.database_inbound_acl_rules[count.index]["rule_number"]
//   rule_action     = var.database_inbound_acl_rules[count.index]["rule_action"]
//   from_port       = lookup(var.database_inbound_acl_rules[count.index], "from_port", null)
//   to_port         = lookup(var.database_inbound_acl_rules[count.index], "to_port", null)
//   icmp_code       = lookup(var.database_inbound_acl_rules[count.index], "icmp_code", null)
//   icmp_type       = lookup(var.database_inbound_acl_rules[count.index], "icmp_type", null)
//   protocol        = var.database_inbound_acl_rules[count.index]["protocol"]
//   cidr_block      = lookup(var.database_inbound_acl_rules[count.index], "cidr_block", null)
//   ipv6_cidr_block = lookup(var.database_inbound_acl_rules[count.index], "ipv6_cidr_block", null)
// }

// resource "aws_network_acl_rule" "database_outbound" {
//   count = var.create_vpc && var.database_dedicated_network_acl && length(var.database_subnets) > 0 ? length(var.database_outbound_acl_rules) : 0

//   network_acl_id = aws_network_acl.database[0].id

//   egress          = true
//   rule_number     = var.database_outbound_acl_rules[count.index]["rule_number"]
//   rule_action     = var.database_outbound_acl_rules[count.index]["rule_action"]
//   from_port       = lookup(var.database_outbound_acl_rules[count.index], "from_port", null)
//   to_port         = lookup(var.database_outbound_acl_rules[count.index], "to_port", null)
//   icmp_code       = lookup(var.database_outbound_acl_rules[count.index], "icmp_code", null)
//   icmp_type       = lookup(var.database_outbound_acl_rules[count.index], "icmp_type", null)
//   protocol        = var.database_outbound_acl_rules[count.index]["protocol"]
//   cidr_block      = lookup(var.database_outbound_acl_rules[count.index], "cidr_block", null)
//   ipv6_cidr_block = lookup(var.database_outbound_acl_rules[count.index], "ipv6_cidr_block", null)
// }