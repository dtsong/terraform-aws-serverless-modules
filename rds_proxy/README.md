<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.14.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.19 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.4.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_db_proxy.db_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy) | resource |
| [aws_db_proxy_default_target_group.rds_proxy_target_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_default_target_group) | resource |
| [aws_db_proxy_target.rds_proxy_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/db_proxy_target) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_engine_family"></a> [engine\_family](#input\_engine\_family) | Engine family for RDS Proxy; only supports POSTGRESQL and MYSQL | `string` | `"POSTGRESQL"` | no |
| <a name="input_name"></a> [name](#input\_name) | Name for the RDS Proxy | `string` | n/a | yes |
| <a name="input_rds_db_identifier"></a> [rds\_db\_identifier](#input\_rds\_db\_identifier) | RDS DB Identifier to be associated with RDS Proxy | `string` | n/a | yes |
| <a name="input_rds_proxy_iam_role_arn"></a> [rds\_proxy\_iam\_role\_arn](#input\_rds\_proxy\_iam\_role\_arn) | IAM Role ARN for the RDS Proxy | `string` | n/a | yes |
| <a name="input_rds_proxy_security_group_id"></a> [rds\_proxy\_security\_group\_id](#input\_rds\_proxy\_security\_group\_id) | Security Group ID for the RDS Proxy | `string` | n/a | yes |
| <a name="input_rds_secret_arn"></a> [rds\_secret\_arn](#input\_rds\_secret\_arn) | Secrets Manager ARN for RDS Proxy access to DB | `string` | n/a | yes |
| <a name="input_vpc_database_subnets"></a> [vpc\_database\_subnets](#input\_vpc\_database\_subnets) | VPC Database Subnets for the RDS Proxy | `map(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_arn"></a> [arn](#output\_arn) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_id"></a> [id](#output\_id) | n/a |
<!-- END_TF_DOCS -->