# Cloud SQL Module - PostgreSQL and SQL Server with HA
# UniCredit GCP Migration

locals {
  is_postgres   = var.database_type == "POSTGRES"
  is_sqlserver  = var.database_type == "SQLSERVER"
  database_tier = var.tier != null ? var.tier : (local.is_postgres ? "db-custom-2-8192" : "db-custom-2-8192")
}

# Cloud SQL Instance
resource "google_sql_database_instance" "instance" {
  name                = var.instance_name
  project             = var.project_id
  region              = var.region
  database_version    = var.database_version
  deletion_protection = var.deletion_protection

  settings {
    tier              = local.database_tier
    availability_type = var.availability_type
    disk_size         = var.disk_size
    disk_type         = var.disk_type
    disk_autoresize   = var.disk_autoresize

    ip_configuration {
      ipv4_enabled                                  = var.enable_public_ip
      private_network                               = var.private_network
      require_ssl                                   = var.require_ssl
      enable_private_path_for_google_cloud_services = true

      dynamic "authorized_networks" {
        for_each = var.authorized_networks
        content {
          name  = authorized_networks.value.name
          value = authorized_networks.value.cidr
        }
      }
    }

    backup_configuration {
      enabled                        = var.backup_enabled
      start_time                     = var.backup_start_time
      point_in_time_recovery_enabled = local.is_postgres ? var.point_in_time_recovery : false
      transaction_log_retention_days = var.transaction_log_retention_days
      backup_retention_settings {
        retained_backups = var.retained_backups
        retention_unit   = "COUNT"
      }
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_update_track
    }

    insights_config {
      query_insights_enabled  = var.query_insights_enabled
      query_plans_per_minute  = var.query_plans_per_minute
      query_string_length     = var.query_string_length
      record_application_tags = true
      record_client_address   = true
    }

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value.name
        value = database_flags.value.value
      }
    }

    user_labels = var.labels
  }

  depends_on = [var.private_vpc_connection]
}

# Databases (PostgreSQL only - SQL Server manages databases differently)
resource "google_sql_database" "databases" {
  for_each = local.is_postgres ? toset(var.databases) : []

  name      = each.value
  project   = var.project_id
  instance  = google_sql_database_instance.instance.name
  charset   = var.database_charset
  collation = var.database_collation
}

# Users
resource "google_sql_user" "users" {
  for_each = { for user in var.users : user.name => user }

  name     = each.value.name
  project  = var.project_id
  instance = google_sql_database_instance.instance.name
  password = each.value.password
  type     = local.is_sqlserver ? "BUILT_IN" : null

  dynamic "password_policy" {
    for_each = local.is_postgres && var.enable_password_policy ? [1] : []
    content {
      allowed_failed_attempts      = 5
      password_expiration_duration = "90d"
      enable_failed_attempts_check = true
    }
  }
}

# Read Replica (optional)
resource "google_sql_database_instance" "read_replica" {
  count = var.create_read_replica ? 1 : 0

  name                 = "${var.instance_name}-replica"
  project              = var.project_id
  region               = var.replica_region != null ? var.replica_region : var.region
  database_version     = var.database_version
  master_instance_name = google_sql_database_instance.instance.name
  deletion_protection  = var.deletion_protection

  replica_configuration {
    failover_target = false
  }

  settings {
    tier            = local.database_tier
    disk_size       = var.disk_size
    disk_type       = var.disk_type
    disk_autoresize = var.disk_autoresize

    ip_configuration {
      ipv4_enabled    = var.enable_public_ip
      private_network = var.private_network
      require_ssl     = var.require_ssl
    }

    user_labels = var.labels
  }
}
