# GCP Cloud Monitoring Uptime Checks
# Terraform configuration for uptime monitoring

variable "app_a_url" {
  description = "App A health check URL"
  type        = string
  default     = ""
}

variable "app_b_url" {
  description = "App B health check URL"
  type        = string
  default     = ""
}

# App A Health Check
resource "google_monitoring_uptime_check_config" "app_a_health" {
  display_name = "App A Health Check"
  project      = var.project_id
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/health"
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.app_a_url
    }
  }

  selected_regions = [
    "EUROPE",
    "USA",
    "ASIA_PACIFIC"
  ]

  content_matchers {
    content = "healthy"
    matcher = "CONTAINS_STRING"
  }
}

# App A API Endpoint Check
resource "google_monitoring_uptime_check_config" "app_a_api" {
  display_name = "App A API Status"
  project      = var.project_id
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/api/status"
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.app_a_url
    }
  }

  selected_regions = [
    "EUROPE",
    "USA",
    "ASIA_PACIFIC"
  ]
}

# App B Health Check
resource "google_monitoring_uptime_check_config" "app_b_health" {
  display_name = "App B Health Check"
  project      = var.project_id
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/health"
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.app_b_url
    }
  }

  selected_regions = [
    "EUROPE",
    "USA",
    "ASIA_PACIFIC"
  ]

  content_matchers {
    content = "Healthy"
    matcher = "CONTAINS_STRING"
  }
}

# App B API Endpoint Check
resource "google_monitoring_uptime_check_config" "app_b_api" {
  display_name = "App B API Status"
  project      = var.project_id
  timeout      = "10s"
  period       = "60s"

  http_check {
    path           = "/api/status"
    port           = 443
    use_ssl        = true
    validate_ssl   = true
    request_method = "GET"

    accepted_response_status_codes {
      status_class = "STATUS_CLASS_2XX"
    }
  }

  monitored_resource {
    type = "uptime_url"
    labels = {
      project_id = var.project_id
      host       = var.app_b_url
    }
  }

  selected_regions = [
    "EUROPE",
    "USA",
    "ASIA_PACIFIC"
  ]
}

# Uptime Check Alert Policies
resource "google_monitoring_alert_policy" "app_a_uptime_alert" {
  display_name = "App A Uptime Check Failed"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "App A Health Check Failure"

    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.app_a_health.uptime_check_id}\""
      duration        = "60s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.\"project_id\""]
      }

      trigger {
        count = 2
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "App A health check is failing. The application may be down or unreachable."
    mime_type = "text/markdown"
  }
}

resource "google_monitoring_alert_policy" "app_b_uptime_alert" {
  display_name = "App B Uptime Check Failed"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "App B Health Check Failure"

    condition_threshold {
      filter          = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" resource.type=\"uptime_url\" metric.label.\"check_id\"=\"${google_monitoring_uptime_check_config.app_b_health.uptime_check_id}\""
      duration        = "60s"
      comparison      = "COMPARISON_LT"
      threshold_value = 1

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_NEXT_OLDER"
        cross_series_reducer = "REDUCE_COUNT_FALSE"
        group_by_fields      = ["resource.label.\"project_id\""]
      }

      trigger {
        count = 2
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "App B health check is failing. The application may be down or unreachable."
    mime_type = "text/markdown"
  }
}
