# Compute Module - Regional Managed Instance Groups
# UniCredit GCP Migration

# Instance Template
resource "google_compute_instance_template" "template" {
  name_prefix  = "${var.name}-"
  project      = var.project_id
  machine_type = var.machine_type
  region       = var.region

  tags = concat(var.network_tags, ["allow-health-check"])

  disk {
    source_image = var.source_image
    auto_delete  = true
    boot         = true
    disk_type    = var.boot_disk_type
    disk_size_gb = var.boot_disk_size_gb

    dynamic "disk_encryption_key" {
      for_each = var.disk_encryption_key != null ? [1] : []
      content {
        kms_key_self_link = var.disk_encryption_key
      }
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork

    dynamic "access_config" {
      for_each = var.enable_public_ip ? [1] : []
      content {
        network_tier = "PREMIUM"
      }
    }
  }

  service_account {
    email  = var.service_account_email
    scopes = var.service_account_scopes
  }

  metadata = merge(var.metadata, {
    enable-oslogin = var.enable_os_login ? "TRUE" : "FALSE"
  })

  dynamic "metadata" {
    for_each = var.startup_script != null ? [1] : []
    content {
      startup-script = var.startup_script
    }
  }

  shielded_instance_config {
    enable_secure_boot          = var.enable_shielded_vm
    enable_vtpm                 = var.enable_shielded_vm
    enable_integrity_monitoring = var.enable_shielded_vm
  }

  lifecycle {
    create_before_destroy = true
  }

  labels = var.labels
}

# Health Check
resource "google_compute_health_check" "health_check" {
  name    = "${var.name}-health-check"
  project = var.project_id

  check_interval_sec  = var.health_check_interval
  timeout_sec         = var.health_check_timeout
  healthy_threshold   = var.healthy_threshold
  unhealthy_threshold = var.unhealthy_threshold

  dynamic "http_health_check" {
    for_each = var.health_check_type == "HTTP" ? [1] : []
    content {
      port         = var.health_check_port
      request_path = var.health_check_path
    }
  }

  dynamic "https_health_check" {
    for_each = var.health_check_type == "HTTPS" ? [1] : []
    content {
      port         = var.health_check_port
      request_path = var.health_check_path
    }
  }

  dynamic "tcp_health_check" {
    for_each = var.health_check_type == "TCP" ? [1] : []
    content {
      port = var.health_check_port
    }
  }
}

# Regional Managed Instance Group
resource "google_compute_region_instance_group_manager" "mig" {
  name    = "${var.name}-mig"
  project = var.project_id
  region  = var.region

  base_instance_name = var.name
  target_size        = var.target_size

  version {
    instance_template = google_compute_instance_template.template.id
    name              = "primary"
  }

  named_port {
    name = var.named_port_name
    port = var.named_port
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.health_check.id
    initial_delay_sec = var.auto_healing_initial_delay
  }

  update_policy {
    type                           = var.update_policy_type
    instance_redistribution_type   = "PROACTIVE"
    minimal_action                 = "REPLACE"
    most_disruptive_allowed_action = "REPLACE"
    max_surge_fixed                = var.max_surge
    max_unavailable_fixed          = var.max_unavailable
    replacement_method             = "SUBSTITUTE"
  }

  distribution_policy_zones = var.zones

  lifecycle {
    create_before_destroy = true
  }
}

# Autoscaler (optional)
resource "google_compute_region_autoscaler" "autoscaler" {
  count = var.enable_autoscaling ? 1 : 0

  name    = "${var.name}-autoscaler"
  project = var.project_id
  region  = var.region
  target  = google_compute_region_instance_group_manager.mig.id

  autoscaling_policy {
    min_replicas    = var.min_replicas
    max_replicas    = var.max_replicas
    cooldown_period = var.cooldown_period

    cpu_utilization {
      target = var.cpu_utilization_target
    }
  }
}
