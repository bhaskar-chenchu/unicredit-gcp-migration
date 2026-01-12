# GCP Cloud Monitoring Log-Based Metrics
# Terraform configuration for custom metrics from logs

# Failed SSH Attempts Metric
resource "google_logging_metric" "failed_ssh_attempts" {
  name        = "failed_ssh_attempts"
  project     = var.project_id
  description = "Count of failed SSH authentication attempts"

  filter = <<-EOT
    resource.type="gce_instance"
    textPayload=~"Failed password|authentication failure|Invalid user"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "instance_id"
      value_type  = "STRING"
      description = "The instance ID"
    }
  }

  label_extractors = {
    "instance_id" = "EXTRACT(resource.labels.instance_id)"
  }
}

# Application Errors Metric (App A - Java)
resource "google_logging_metric" "app_a_errors" {
  name        = "app_a_errors"
  project     = var.project_id
  description = "Count of App A application errors"

  filter = <<-EOT
    resource.type="gce_instance"
    resource.labels.instance_id=~"app-a.*"
    severity="ERROR"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "instance_id"
      value_type  = "STRING"
      description = "The instance ID"
    }

    labels {
      key         = "error_type"
      value_type  = "STRING"
      description = "Type of error"
    }
  }

  label_extractors = {
    "instance_id" = "EXTRACT(resource.labels.instance_id)"
    "error_type"  = "REGEXP_EXTRACT(textPayload, \"(Exception|Error|SEVERE)\")"
  }
}

# Application Errors Metric (App B - .NET)
resource "google_logging_metric" "app_b_errors" {
  name        = "app_b_errors"
  project     = var.project_id
  description = "Count of App B application errors"

  filter = <<-EOT
    resource.type="gce_instance"
    resource.labels.instance_id=~"app-b.*"
    textPayload=~"Exception|Error|FATAL"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "instance_id"
      value_type  = "STRING"
      description = "The instance ID"
    }
  }

  label_extractors = {
    "instance_id" = "EXTRACT(resource.labels.instance_id)"
  }
}

# Slow Database Queries Metric
resource "google_logging_metric" "slow_queries" {
  name        = "slow_database_queries"
  project     = var.project_id
  description = "Count of slow database queries"

  filter = <<-EOT
    resource.type="cloudsql_database"
    textPayload=~"duration: [0-9]{4,}\\.[0-9]+ ms"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "database"
      value_type  = "STRING"
      description = "Database name"
    }
  }

  label_extractors = {
    "database" = "EXTRACT(resource.labels.database_id)"
  }
}

# Authentication Failures Metric (Windows)
resource "google_logging_metric" "windows_auth_failures" {
  name        = "windows_auth_failures"
  project     = var.project_id
  description = "Count of Windows authentication failures"

  filter = <<-EOT
    resource.type="gce_instance"
    jsonPayload.EventID="4625"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "instance_id"
      value_type  = "STRING"
      description = "The instance ID"
    }
  }

  label_extractors = {
    "instance_id" = "EXTRACT(resource.labels.instance_id)"
  }
}

# IAM Policy Changes Metric
resource "google_logging_metric" "iam_policy_changes" {
  name        = "iam_policy_changes"
  project     = var.project_id
  description = "Count of IAM policy changes"

  filter = <<-EOT
    protoPayload.methodName=~"SetIamPolicy|CreateServiceAccount|DeleteServiceAccount"
    resource.type="project"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "method"
      value_type  = "STRING"
      description = "The method name"
    }

    labels {
      key         = "actor"
      value_type  = "STRING"
      description = "The actor who made the change"
    }
  }

  label_extractors = {
    "method" = "EXTRACT(protoPayload.methodName)"
    "actor"  = "EXTRACT(protoPayload.authenticationInfo.principalEmail)"
  }
}

# Firewall Rule Changes Metric
resource "google_logging_metric" "firewall_changes" {
  name        = "firewall_rule_changes"
  project     = var.project_id
  description = "Count of firewall rule changes"

  filter = <<-EOT
    resource.type="gce_firewall_rule"
    protoPayload.methodName=~"insert|delete|patch|update"
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "action"
      value_type  = "STRING"
      description = "The action performed"
    }
  }

  label_extractors = {
    "action" = "EXTRACT(protoPayload.methodName)"
  }
}

# HTTP 4xx Errors Metric
resource "google_logging_metric" "http_4xx_errors" {
  name        = "http_4xx_errors"
  project     = var.project_id
  description = "Count of HTTP 4xx errors from load balancer"

  filter = <<-EOT
    resource.type="http_load_balancer"
    httpRequest.status>=400
    httpRequest.status<500
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "status_code"
      value_type  = "INT64"
      description = "HTTP status code"
    }

    labels {
      key         = "url"
      value_type  = "STRING"
      description = "Request URL"
    }
  }

  label_extractors = {
    "status_code" = "EXTRACT(httpRequest.status)"
    "url"         = "EXTRACT(httpRequest.requestUrl)"
  }
}

# HTTP 5xx Errors Metric
resource "google_logging_metric" "http_5xx_errors" {
  name        = "http_5xx_errors"
  project     = var.project_id
  description = "Count of HTTP 5xx errors from load balancer"

  filter = <<-EOT
    resource.type="http_load_balancer"
    httpRequest.status>=500
  EOT

  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    unit        = "1"

    labels {
      key         = "status_code"
      value_type  = "INT64"
      description = "HTTP status code"
    }

    labels {
      key         = "backend_service"
      value_type  = "STRING"
      description = "Backend service name"
    }
  }

  label_extractors = {
    "status_code"     = "EXTRACT(httpRequest.status)"
    "backend_service" = "EXTRACT(resource.labels.backend_service_name)"
  }
}
