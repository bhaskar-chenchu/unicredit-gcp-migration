# Cloud SQL Module Outputs

output "instance_name" {
  description = "Instance name"
  value       = google_sql_database_instance.instance.name
}

output "instance_connection_name" {
  description = "Instance connection name for Cloud SQL Proxy"
  value       = google_sql_database_instance.instance.connection_name
}

output "instance_self_link" {
  description = "Instance self link"
  value       = google_sql_database_instance.instance.self_link
}

output "private_ip_address" {
  description = "Private IP address"
  value       = google_sql_database_instance.instance.private_ip_address
}

output "public_ip_address" {
  description = "Public IP address"
  value       = google_sql_database_instance.instance.public_ip_address
}

output "server_ca_cert" {
  description = "Server CA certificate"
  value       = google_sql_database_instance.instance.server_ca_cert
  sensitive   = true
}

output "database_names" {
  description = "List of created database names"
  value       = [for db in google_sql_database.databases : db.name]
}

output "user_names" {
  description = "List of created user names"
  value       = [for user in google_sql_user.users : user.name]
}

output "replica_instance_name" {
  description = "Read replica instance name"
  value       = var.create_read_replica ? google_sql_database_instance.read_replica[0].name : null
}

output "replica_connection_name" {
  description = "Read replica connection name"
  value       = var.create_read_replica ? google_sql_database_instance.read_replica[0].connection_name : null
}

output "replica_private_ip" {
  description = "Read replica private IP"
  value       = var.create_read_replica ? google_sql_database_instance.read_replica[0].private_ip_address : null
}
