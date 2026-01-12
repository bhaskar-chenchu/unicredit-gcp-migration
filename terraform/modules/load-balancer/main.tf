# Load Balancer Module - HTTP(S) Load Balancer
# UniCredit GCP Migration

# Reserved External IP
resource "google_compute_global_address" "lb_ip" {
  name    = "${var.name}-ip"
  project = var.project_id
}

# Backend Service
resource "google_compute_backend_service" "backend" {
  name    = "${var.name}-backend"
  project = var.project_id

  protocol              = var.protocol
  port_name             = var.port_name
  timeout_sec           = var.timeout_sec
  enable_cdn            = var.enable_cdn
  load_balancing_scheme = "EXTERNAL_MANAGED"

  dynamic "backend" {
    for_each = var.backends
    content {
      group                 = backend.value.instance_group
      balancing_mode        = backend.value.balancing_mode
      capacity_scaler       = backend.value.capacity_scaler
      max_utilization       = backend.value.max_utilization
      max_rate_per_instance = backend.value.max_rate_per_instance
    }
  }

  health_checks = [var.health_check]

  log_config {
    enable      = var.enable_logging
    sample_rate = var.log_sample_rate
  }

  dynamic "iap" {
    for_each = var.enable_iap ? [1] : []
    content {
      oauth2_client_id     = var.iap_oauth2_client_id
      oauth2_client_secret = var.iap_oauth2_client_secret
    }
  }
}

# URL Map
resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.backend.id

  dynamic "host_rule" {
    for_each = var.host_rules
    content {
      hosts        = host_rule.value.hosts
      path_matcher = host_rule.value.path_matcher
    }
  }

  dynamic "path_matcher" {
    for_each = var.path_matchers
    content {
      name            = path_matcher.value.name
      default_service = google_compute_backend_service.backend.id

      dynamic "path_rule" {
        for_each = path_matcher.value.path_rules
        content {
          paths   = path_rule.value.paths
          service = path_rule.value.service
        }
      }
    }
  }
}

# HTTP Proxy (for redirect to HTTPS)
resource "google_compute_target_http_proxy" "http_proxy" {
  count = var.enable_http_redirect ? 1 : 0

  name    = "${var.name}-http-proxy"
  project = var.project_id
  url_map = google_compute_url_map.http_redirect[0].id
}

# HTTP to HTTPS Redirect URL Map
resource "google_compute_url_map" "http_redirect" {
  count = var.enable_http_redirect ? 1 : 0

  name    = "${var.name}-http-redirect"
  project = var.project_id

  default_url_redirect {
    https_redirect         = true
    redirect_response_code = "MOVED_PERMANENTLY_DEFAULT"
    strip_query            = false
  }
}

# HTTPS Proxy
resource "google_compute_target_https_proxy" "https_proxy" {
  name    = "${var.name}-https-proxy"
  project = var.project_id
  url_map = google_compute_url_map.url_map.id

  ssl_certificates = var.ssl_certificates
  ssl_policy       = var.ssl_policy
}

# HTTP Forwarding Rule (for redirect)
resource "google_compute_global_forwarding_rule" "http" {
  count = var.enable_http_redirect ? 1 : 0

  name       = "${var.name}-http-forwarding"
  project    = var.project_id
  target     = google_compute_target_http_proxy.http_proxy[0].id
  ip_address = google_compute_global_address.lb_ip.address
  port_range = "80"
}

# HTTPS Forwarding Rule
resource "google_compute_global_forwarding_rule" "https" {
  name       = "${var.name}-https-forwarding"
  project    = var.project_id
  target     = google_compute_target_https_proxy.https_proxy.id
  ip_address = google_compute_global_address.lb_ip.address
  port_range = "443"
}

# Managed SSL Certificate (optional)
resource "google_compute_managed_ssl_certificate" "certificate" {
  count = var.create_managed_certificate ? 1 : 0

  name    = "${var.name}-certificate"
  project = var.project_id

  managed {
    domains = var.managed_certificate_domains
  }
}
