# GCP Cloud Monitoring Alerting Policies
# Terraform configuration for alerting

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "notification_channels" {
  description = "List of notification channel IDs"
  type        = list(string)
  default     = []
}

# High CPU Utilization Alert
resource "google_monitoring_alert_policy" "high_cpu" {
  display_name = "High CPU Utilization"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "CPU utilization > 85%"

    condition_threshold {
      filter          = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.85

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "CPU utilization has exceeded 85% for 5 minutes. Consider scaling up or investigating high CPU processes."
    mime_type = "text/markdown"
  }
}

# High Memory Utilization Alert
resource "google_monitoring_alert_policy" "high_memory" {
  display_name = "High Memory Utilization"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Memory utilization > 90%"

    condition_threshold {
      filter          = "metric.type=\"agent.googleapis.com/memory/percent_used\" resource.type=\"gce_instance\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 90

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "Memory utilization has exceeded 90% for 5 minutes. Investigate memory usage and consider scaling."
    mime_type = "text/markdown"
  }
}

# Instance Down Alert
resource "google_monitoring_alert_policy" "instance_down" {
  display_name = "Instance Down"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Instance not running"

    condition_absent {
      filter   = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      duration = "300s"

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }
    }
  }

  notification_channels = var.notification_channels

  alert_strategy {
    auto_close = "1800s"
  }

  documentation {
    content   = "A compute instance appears to be down. Check instance status and investigate."
    mime_type = "text/markdown"
  }
}

# High Error Rate Alert
resource "google_monitoring_alert_policy" "high_error_rate" {
  display_name = "High HTTP Error Rate"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "5xx error rate > 5%"

    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/request_count\" resource.type=\"https_lb_rule\" metric.label.\"response_code_class\"=\"500\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.05

      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "HTTP 5xx error rate has exceeded 5% for 5 minutes. Investigate application errors."
    mime_type = "text/markdown"
  }
}

# High Latency Alert
resource "google_monitoring_alert_policy" "high_latency" {
  display_name = "High Response Latency"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "P99 latency > 2 seconds"

    condition_threshold {
      filter          = "metric.type=\"loadbalancing.googleapis.com/https/backend_latencies\" resource.type=\"https_lb_rule\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 2000

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_PERCENTILE_99"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "P99 response latency has exceeded 2 seconds. Investigate slow requests."
    mime_type = "text/markdown"
  }
}

# Cloud SQL High Connections Alert
resource "google_monitoring_alert_policy" "cloudsql_high_connections" {
  display_name = "Cloud SQL High Connection Count"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "PostgreSQL connections > 80% of max"

    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/postgresql/num_backends\" resource.type=\"cloudsql_database\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 80

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "Cloud SQL connection count is approaching the maximum. Consider connection pooling or increasing max connections."
    mime_type = "text/markdown"
  }
}

# Cloud SQL Replication Lag Alert
resource "google_monitoring_alert_policy" "cloudsql_replication_lag" {
  display_name = "Cloud SQL Replication Lag"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Replication lag > 30 seconds"

    condition_threshold {
      filter          = "metric.type=\"cloudsql.googleapis.com/database/replication/replica_lag\" resource.type=\"cloudsql_database\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 30

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "Cloud SQL replication lag has exceeded 30 seconds. Investigate replica performance."
    mime_type = "text/markdown"
  }
}

# Disk Usage Alert
resource "google_monitoring_alert_policy" "high_disk_usage" {
  display_name = "High Disk Usage"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Disk usage > 85%"

    condition_threshold {
      filter          = "metric.type=\"agent.googleapis.com/disk/percent_used\" resource.type=\"gce_instance\""
      duration        = "300s"
      comparison      = "COMPARISON_GT"
      threshold_value = 85

      aggregations {
        alignment_period   = "60s"
        per_series_aligner = "ALIGN_MEAN"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "Disk usage has exceeded 85%. Consider expanding disk or cleaning up old files."
    mime_type = "text/markdown"
  }
}

# Security - Failed SSH Attempts Alert
resource "google_monitoring_alert_policy" "failed_ssh" {
  display_name = "High Failed SSH Attempts"
  project      = var.project_id
  combiner     = "OR"

  conditions {
    display_name = "Failed SSH attempts > 10 in 5 minutes"

    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/failed_ssh_attempts\" resource.type=\"gce_instance\""
      duration        = "0s"
      comparison      = "COMPARISON_GT"
      threshold_value = 10

      aggregations {
        alignment_period   = "300s"
        per_series_aligner = "ALIGN_SUM"
      }

      trigger {
        count = 1
      }
    }
  }

  notification_channels = var.notification_channels

  documentation {
    content   = "High number of failed SSH attempts detected. Possible brute force attack."
    mime_type = "text/markdown"
  }
}
