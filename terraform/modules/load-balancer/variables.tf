# Load Balancer Module Variables

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "name" {
  description = "Name prefix for resources"
  type        = string
}

variable "backends" {
  description = "List of backend configurations"
  type = list(object({
    instance_group        = string
    balancing_mode        = string
    capacity_scaler       = number
    max_utilization       = number
    max_rate_per_instance = number
  }))
}

variable "health_check" {
  description = "Health check self link"
  type        = string
}

variable "protocol" {
  description = "Backend protocol (HTTP, HTTPS)"
  type        = string
  default     = "HTTP"
}

variable "port_name" {
  description = "Named port for backend"
  type        = string
  default     = "http"
}

variable "timeout_sec" {
  description = "Backend timeout in seconds"
  type        = number
  default     = 30
}

variable "enable_cdn" {
  description = "Enable Cloud CDN"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enable access logging"
  type        = bool
  default     = true
}

variable "log_sample_rate" {
  description = "Log sample rate (0.0 to 1.0)"
  type        = number
  default     = 1.0
}

variable "enable_iap" {
  description = "Enable Identity-Aware Proxy"
  type        = bool
  default     = false
}

variable "iap_oauth2_client_id" {
  description = "OAuth2 client ID for IAP"
  type        = string
  default     = ""
}

variable "iap_oauth2_client_secret" {
  description = "OAuth2 client secret for IAP"
  type        = string
  default     = ""
  sensitive   = true
}

variable "host_rules" {
  description = "Host rules for URL map"
  type = list(object({
    hosts        = list(string)
    path_matcher = string
  }))
  default = []
}

variable "path_matchers" {
  description = "Path matchers for URL map"
  type = list(object({
    name = string
    path_rules = list(object({
      paths   = list(string)
      service = string
    }))
  }))
  default = []
}

variable "ssl_certificates" {
  description = "List of SSL certificate self links"
  type        = list(string)
}

variable "ssl_policy" {
  description = "SSL policy self link"
  type        = string
  default     = null
}

variable "enable_http_redirect" {
  description = "Enable HTTP to HTTPS redirect"
  type        = bool
  default     = true
}

variable "create_managed_certificate" {
  description = "Create a managed SSL certificate"
  type        = bool
  default     = false
}

variable "managed_certificate_domains" {
  description = "Domains for managed certificate"
  type        = list(string)
  default     = []
}
