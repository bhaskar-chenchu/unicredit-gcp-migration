# Terratest Fixture for Load Balancer Module

module "load_balancer" {
  source = "../../../../terraform/modules/load-balancer"

  project_id      = var.project_id
  region          = var.region
  environment     = var.environment
  name            = var.name
  enable_https    = var.enable_https
  ssl_policy      = var.ssl_policy
  min_tls_version = var.min_tls_version
  backends        = var.backends
  health_check    = var.health_check
  url_map_rules   = var.url_map_rules
  enable_cdn      = var.enable_cdn
  cdn_policy      = var.cdn_policy
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

variable "name" {
  type    = string
  default = "test-lb"
}

variable "enable_https" {
  type    = bool
  default = true
}

variable "ssl_policy" {
  type    = string
  default = "MODERN"
}

variable "min_tls_version" {
  type    = string
  default = "TLS_1_2"
}

variable "backends" {
  type = list(object({
    group           = string
    balancing_mode  = string
    capacity_scaler = number
  }))
  default = []
}

variable "health_check" {
  type = object({
    check_interval_sec  = number
    timeout_sec         = number
    healthy_threshold   = number
    unhealthy_threshold = number
    request_path        = string
    port                = number
  })
  default = {
    check_interval_sec  = 10
    timeout_sec         = 5
    healthy_threshold   = 2
    unhealthy_threshold = 3
    request_path        = "/health"
    port                = 8080
  }
}

variable "url_map_rules" {
  type = list(object({
    hosts        = list(string)
    path_matcher = string
    backend      = string
  }))
  default = []
}

variable "enable_cdn" {
  type    = bool
  default = false
}

variable "cdn_policy" {
  type = object({
    cache_mode        = string
    default_ttl       = number
    max_ttl           = number
    negative_caching  = bool
    serve_while_stale = number
  })
  default = null
}
