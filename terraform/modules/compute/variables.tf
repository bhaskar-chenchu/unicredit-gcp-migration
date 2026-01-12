# Compute Module Variables

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zones" {
  description = "List of zones for instance distribution"
  type        = list(string)
}

variable "machine_type" {
  description = "Machine type for instances"
  type        = string
  default     = "n2-standard-2"
}

variable "source_image" {
  description = "Source image for boot disk"
  type        = string
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-ssd"
}

variable "boot_disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 50
}

variable "disk_encryption_key" {
  description = "KMS key for disk encryption"
  type        = string
  default     = null
}

variable "network" {
  description = "VPC network self link"
  type        = string
}

variable "subnetwork" {
  description = "Subnetwork self link"
  type        = string
}

variable "enable_public_ip" {
  description = "Enable public IP on instances"
  type        = bool
  default     = false
}

variable "network_tags" {
  description = "Network tags for firewall rules"
  type        = list(string)
  default     = []
}

variable "service_account_email" {
  description = "Service account email"
  type        = string
}

variable "service_account_scopes" {
  description = "Service account scopes"
  type        = list(string)
  default     = ["cloud-platform"]
}

variable "metadata" {
  description = "Instance metadata"
  type        = map(string)
  default     = {}
}

variable "startup_script" {
  description = "Startup script content"
  type        = string
  default     = null
}

variable "enable_os_login" {
  description = "Enable OS Login"
  type        = bool
  default     = true
}

variable "enable_shielded_vm" {
  description = "Enable Shielded VM features"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to resources"
  type        = map(string)
  default     = {}
}

# Instance Group Settings
variable "target_size" {
  description = "Target number of instances"
  type        = number
  default     = 2
}

variable "named_port_name" {
  description = "Name for the named port"
  type        = string
  default     = "http"
}

variable "named_port" {
  description = "Port number for named port"
  type        = number
  default     = 8080
}

# Health Check Settings
variable "health_check_type" {
  description = "Health check type (HTTP, HTTPS, TCP)"
  type        = string
  default     = "HTTP"
}

variable "health_check_port" {
  description = "Port for health check"
  type        = number
  default     = 8080
}

variable "health_check_path" {
  description = "Path for HTTP/HTTPS health check"
  type        = string
  default     = "/health"
}

variable "health_check_interval" {
  description = "Health check interval in seconds"
  type        = number
  default     = 10
}

variable "health_check_timeout" {
  description = "Health check timeout in seconds"
  type        = number
  default     = 5
}

variable "healthy_threshold" {
  description = "Healthy threshold"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "Unhealthy threshold"
  type        = number
  default     = 3
}

variable "auto_healing_initial_delay" {
  description = "Initial delay for auto-healing in seconds"
  type        = number
  default     = 300
}

# Update Policy
variable "update_policy_type" {
  description = "Update policy type (PROACTIVE or OPPORTUNISTIC)"
  type        = string
  default     = "PROACTIVE"
}

variable "max_surge" {
  description = "Maximum surge instances during update"
  type        = number
  default     = 1
}

variable "max_unavailable" {
  description = "Maximum unavailable instances during update"
  type        = number
  default     = 0
}

# Autoscaling
variable "enable_autoscaling" {
  description = "Enable autoscaling"
  type        = bool
  default     = false
}

variable "min_replicas" {
  description = "Minimum number of replicas"
  type        = number
  default     = 2
}

variable "max_replicas" {
  description = "Maximum number of replicas"
  type        = number
  default     = 10
}

variable "cooldown_period" {
  description = "Autoscaler cooldown period in seconds"
  type        = number
  default     = 60
}

variable "cpu_utilization_target" {
  description = "Target CPU utilization for autoscaling"
  type        = number
  default     = 0.7
}
