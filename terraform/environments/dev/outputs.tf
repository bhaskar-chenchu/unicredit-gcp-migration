# Development Environment Outputs

output "vpc_id" {
  description = "VPC network ID"
  value       = module.network.vpc_id
}

output "postgres_instance_name" {
  description = "PostgreSQL instance name"
  value       = module.cloudsql_postgres.instance_name
}

output "postgres_private_ip" {
  description = "PostgreSQL private IP"
  value       = module.cloudsql_postgres.private_ip_address
}

output "postgres_connection_name" {
  description = "PostgreSQL connection name"
  value       = module.cloudsql_postgres.instance_connection_name
}

output "sqlserver_instance_name" {
  description = "SQL Server instance name"
  value       = module.cloudsql_sqlserver.instance_name
}

output "sqlserver_private_ip" {
  description = "SQL Server private IP"
  value       = module.cloudsql_sqlserver.private_ip_address
}

output "sqlserver_connection_name" {
  description = "SQL Server connection name"
  value       = module.cloudsql_sqlserver.instance_connection_name
}

output "app_a_instance_group" {
  description = "Application A instance group"
  value       = module.compute_app_a.instance_group
}

output "app_b_instance_group" {
  description = "Application B instance group"
  value       = module.compute_app_b.instance_group
}

output "service_accounts" {
  description = "Service account emails"
  value       = module.iam.service_account_emails
}
