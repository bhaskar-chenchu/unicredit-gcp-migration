# Cloud SQL Module Variables

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "instance_name" {
  description = "Cloud SQL instance name"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "database_type" {
  description = "Database type (POSTGRES or SQLSERVER)"
  type        = string
  validation {
    condition     = contains(["POSTGRES", "SQLSERVER"], var.database_type)
    error_message = "database_type must be POSTGRES or SQLSERVER"
  }
}

variable "database_version" {
  description = "Database version (e.g., POSTGRES_15, SQLSERVER_2019_STANDARD)"
  type        = string
}

variable "tier" {
  description = "Machine tier (e.g., db-custom-2-8192)"
  type        = string
  default     = null
}

variable "availability_type" {
  description = "Availability type (REGIONAL for HA, ZONAL for single zone)"
  type        = string
  default     = "REGIONAL"
}

variable "disk_size" {
  description = "Disk size in GB"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Disk type (PD_SSD or PD_HDD)"
  type        = string
  default     = "PD_SSD"
}

variable "disk_autoresize" {
  description = "Enable disk autoresize"
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Enable deletion protection"
  type        = bool
  default     = true
}

# Network
variable "private_network" {
  description = "VPC network self link for private IP"
  type        = string
}

variable "private_vpc_connection" {
  description = "Private VPC connection dependency"
  type        = string
  default     = null
}

variable "enable_public_ip" {
  description = "Enable public IP"
  type        = bool
  default     = false
}

variable "require_ssl" {
  description = "Require SSL connections"
  type        = bool
  default     = true
}

variable "authorized_networks" {
  description = "Authorized networks for public IP access"
  type = list(object({
    name = string
    cidr = string
  }))
  default = []
}

# Backup
variable "backup_enabled" {
  description = "Enable automated backups"
  type        = bool
  default     = true
}

variable "backup_start_time" {
  description = "Backup start time (HH:MM format)"
  type        = string
  default     = "03:00"
}

variable "point_in_time_recovery" {
  description = "Enable point-in-time recovery (PostgreSQL only)"
  type        = bool
  default     = true
}

variable "transaction_log_retention_days" {
  description = "Transaction log retention days"
  type        = number
  default     = 7
}

variable "retained_backups" {
  description = "Number of backups to retain"
  type        = number
  default     = 7
}

# Maintenance
variable "maintenance_window_day" {
  description = "Maintenance window day (1-7, Sunday=1)"
  type        = number
  default     = 7
}

variable "maintenance_window_hour" {
  description = "Maintenance window hour (0-23)"
  type        = number
  default     = 3
}

variable "maintenance_update_track" {
  description = "Maintenance update track (stable or canary)"
  type        = string
  default     = "stable"
}

# Query Insights
variable "query_insights_enabled" {
  description = "Enable query insights"
  type        = bool
  default     = true
}

variable "query_plans_per_minute" {
  description = "Query plans per minute"
  type        = number
  default     = 5
}

variable "query_string_length" {
  description = "Query string length"
  type        = number
  default     = 1024
}

# Database Flags
variable "database_flags" {
  description = "Database flags"
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# Databases (PostgreSQL)
variable "databases" {
  description = "List of databases to create"
  type        = list(string)
  default     = []
}

variable "database_charset" {
  description = "Database charset"
  type        = string
  default     = "UTF8"
}

variable "database_collation" {
  description = "Database collation"
  type        = string
  default     = "en_US.UTF8"
}

# Users
variable "users" {
  description = "List of users to create"
  type = list(object({
    name     = string
    password = string
  }))
  default   = []
  sensitive = true
}

variable "enable_password_policy" {
  description = "Enable password policy for users"
  type        = bool
  default     = true
}

# Read Replica
variable "create_read_replica" {
  description = "Create a read replica"
  type        = bool
  default     = false
}

variable "replica_region" {
  description = "Region for read replica"
  type        = string
  default     = null
}

# Labels
variable "labels" {
  description = "Labels to apply"
  type        = map(string)
  default     = {}
}
