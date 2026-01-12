# Terratest Fixture for IAM Module

module "iam" {
  source = "../../../../terraform/modules/iam"

  project_id               = var.project_id
  environment              = var.environment
  service_accounts         = var.service_accounts
  role_bindings            = var.role_bindings
  enable_workload_identity = var.enable_workload_identity
  workload_identity_config = var.workload_identity_config
  account_type             = var.account_type
}

variable "project_id" {
  type = string
}

variable "environment" {
  type    = string
  default = "test"
}

variable "service_accounts" {
  type = list(object({
    account_id   = string
    display_name = string
    description  = string
  }))
  default = []
}

variable "role_bindings" {
  type = list(object({
    role    = string
    members = list(string)
  }))
  default = []
}

variable "enable_workload_identity" {
  type    = bool
  default = false
}

variable "workload_identity_config" {
  type = object({
    namespace           = string
    service_account     = string
    gcp_service_account = string
  })
  default = null
}

variable "account_type" {
  type    = string
  default = "application"
}
