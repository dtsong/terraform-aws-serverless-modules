output "security_group_id" {
  description = "The ID of the security group"
  value       = try(module.security_group.id, "")
}

output "security_group_vpc_id" {
  description = "The VPC ID"
  value       = try(module.security_group.vpc_id, "")
}

output "security_group_owner_id" {
  description = "The owner ID"
  value       = try(module.security_group.owner_id, "")
}

output "security_group_name" {
  description = "The name of the security group"
  value       = try(module.security_group.name, "")
}

output "security_group_description" {
  description = "The description of the security group"
  value       = try(module.security_group.description, "")
}
