# IAM Module - Service Accounts and IAM Bindings
# UniCredit GCP Migration

# Service Accounts
resource "google_service_account" "service_accounts" {
  for_each = { for sa in var.service_accounts : sa.name => sa }

  account_id   = each.value.name
  display_name = each.value.display_name
  project      = var.project_id
  description  = each.value.description
}

# Project-level IAM bindings for service accounts
resource "google_project_iam_member" "service_account_roles" {
  for_each = {
    for binding in local.sa_role_bindings : "${binding.sa_name}-${binding.role}" => binding
  }

  project = var.project_id
  role    = each.value.role
  member  = "serviceAccount:${google_service_account.service_accounts[each.value.sa_name].email}"
}

locals {
  sa_role_bindings = flatten([
    for sa in var.service_accounts : [
      for role in sa.roles : {
        sa_name = sa.name
        role    = role
      }
    ]
  ])
}

# Custom IAM Role (optional)
resource "google_project_iam_custom_role" "custom_roles" {
  for_each = { for role in var.custom_roles : role.role_id => role }

  role_id     = each.value.role_id
  title       = each.value.title
  description = each.value.description
  project     = var.project_id
  permissions = each.value.permissions
  stage       = "GA"
}

# Workload Identity Pool (optional)
resource "google_iam_workload_identity_pool" "pool" {
  count = var.create_workload_identity_pool ? 1 : 0

  workload_identity_pool_id = var.workload_identity_pool_id
  project                   = var.project_id
  display_name              = var.workload_identity_pool_display_name
  description               = var.workload_identity_pool_description
}

# Service Account Key (use with caution - prefer Workload Identity)
resource "google_service_account_key" "keys" {
  for_each = toset(var.service_accounts_with_keys)

  service_account_id = google_service_account.service_accounts[each.value].name
  key_algorithm      = "KEY_ALG_RSA_2048"
}
