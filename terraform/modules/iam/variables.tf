# IAM Module Variables

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "service_accounts" {
  description = "List of service accounts to create"
  type = list(object({
    name         = string
    display_name = string
    description  = string
    roles        = list(string)
  }))
  default = []
}

variable "custom_roles" {
  description = "List of custom roles to create"
  type = list(object({
    role_id     = string
    title       = string
    description = string
    permissions = list(string)
  }))
  default = []
}

variable "create_workload_identity_pool" {
  description = "Create a Workload Identity Pool"
  type        = bool
  default     = false
}

variable "workload_identity_pool_id" {
  description = "Workload Identity Pool ID"
  type        = string
  default     = "default-pool"
}

variable "workload_identity_pool_display_name" {
  description = "Workload Identity Pool display name"
  type        = string
  default     = "Default Pool"
}

variable "workload_identity_pool_description" {
  description = "Workload Identity Pool description"
  type        = string
  default     = "Workload Identity Pool for external identity providers"
}

variable "service_accounts_with_keys" {
  description = "List of service account names that need keys generated"
  type        = list(string)
  default     = []
}
