# Development Environment Variables

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default     = "us-central1"
}

variable "zones" {
  description = "GCP Zones"
  type        = list(string)
  default     = ["us-central1-a", "us-central1-b"]
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "dev"
}

variable "ssh_source_ranges" {
  description = "Source ranges for SSH access"
  type        = list(string)
  default     = ["35.235.240.0/20"] # IAP range
}

variable "rdp_source_ranges" {
  description = "Source ranges for RDP access"
  type        = list(string)
  default     = ["35.235.240.0/20"] # IAP range
}

variable "app_a_image" {
  description = "Image for Application A (RHEL 9 + WildFly)"
  type        = string
}

variable "app_b_image" {
  description = "Image for Application B (Windows Server 2022 + IIS)"
  type        = string
}

variable "postgres_password" {
  description = "PostgreSQL user password"
  type        = string
  sensitive   = true
}

variable "sqlserver_password" {
  description = "SQL Server user password"
  type        = string
  sensitive   = true
}
