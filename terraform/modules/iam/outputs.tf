# IAM Module Outputs

output "service_accounts" {
  description = "Map of service account names to their details"
  value = {
    for name, sa in google_service_account.service_accounts : name => {
      email     = sa.email
      unique_id = sa.unique_id
      name      = sa.name
    }
  }
}

output "service_account_emails" {
  description = "Map of service account names to emails"
  value = {
    for name, sa in google_service_account.service_accounts : name => sa.email
  }
}

output "custom_role_ids" {
  description = "Map of custom role IDs"
  value = {
    for role_id, role in google_project_iam_custom_role.custom_roles : role_id => role.id
  }
}

output "service_account_keys" {
  description = "Map of service account keys (base64 encoded)"
  value = {
    for name, key in google_service_account_key.keys : name => key.private_key
  }
  sensitive = true
}

output "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  value       = var.create_workload_identity_pool ? google_iam_workload_identity_pool.pool[0].workload_identity_pool_id : null
}
