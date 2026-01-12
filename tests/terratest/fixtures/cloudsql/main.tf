# Terratest Fixture for Cloud SQL Module

module "cloudsql" {
  source = "../../../../terraform/modules/cloudsql"

  project_id                     = var.project_id
  region                         = var.region
  environment                    = var.environment
  instance_name                  = var.instance_name
  database_type                  = var.database_type
  database_version               = var.database_version
  tier                           = var.tier
  high_availability              = var.high_availability
  availability_type              = var.availability_type
  ipv4_enabled                   = var.ipv4_enabled
  private_network                = var.private_network
  backup_enabled                 = var.backup_enabled
  backup_start_time              = var.backup_start_time
  retained_backups               = var.retained_backups
  transaction_log_retention_days = var.transaction_log_retention_days
  deletion_protection            = var.deletion_protection
}

variable "project_id" {
  type = string
}

variable "region" {
  type    = string
  default = "europe-west1"
}

variable "environment" {
  type    = string
  default = "test"
}

variable "instance_name" {
  type    = string
  default = "test-db"
}

variable "database_type" {
  type    = string
  default = "postgresql"
}

variable "database_version" {
  type    = string
  default = "POSTGRES_15"
}

variable "tier" {
  type    = string
  default = "db-custom-2-4096"
}

variable "high_availability" {
  type    = bool
  default = false
}

variable "availability_type" {
  type    = string
  default = "ZONAL"
}

variable "ipv4_enabled" {
  type    = bool
  default = false
}

variable "private_network" {
  type    = string
  default = ""
}

variable "backup_enabled" {
  type    = bool
  default = true
}

variable "backup_start_time" {
  type    = string
  default = "03:00"
}

variable "retained_backups" {
  type    = number
  default = 7
}

variable "transaction_log_retention_days" {
  type    = number
  default = 7
}

variable "deletion_protection" {
  type    = bool
  default = false
}
