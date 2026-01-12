# Development Environment Configuration
# UniCredit GCP Migration

terraform {
  required_version = ">= 1.5.0"

  backend "gcs" {
    bucket = "unicredit-terraform-state"
    prefix = "dev"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "google-beta" {
  project = var.project_id
  region  = var.region
}

# Network Module
module "network" {
  source = "../../modules/network"

  project_id = var.project_id
  vpc_name   = "${var.environment}-vpc"

  subnets = [
    {
      name                        = "${var.environment}-subnet-01"
      region                      = var.region
      ip_cidr_range               = "10.0.0.0/24"
      secondary_ip_range_pods     = "10.1.0.0/16"
      secondary_ip_range_services = "10.2.0.0/20"
    }
  ]

  nat_regions       = [var.region]
  ssh_source_ranges = var.ssh_source_ranges
  rdp_source_ranges = var.rdp_source_ranges
}

# IAM Module
module "iam" {
  source = "../../modules/iam"

  project_id = var.project_id

  service_accounts = [
    {
      name         = "app-a-compute"
      display_name = "Application A Compute Service Account"
      description  = "Service account for Application A VMs"
      roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/cloudsql.client"
      ]
    },
    {
      name         = "app-b-compute"
      display_name = "Application B Compute Service Account"
      description  = "Service account for Application B VMs"
      roles = [
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
        "roles/cloudsql.client"
      ]
    }
  ]
}

# Cloud SQL - PostgreSQL for Application A
module "cloudsql_postgres" {
  source = "../../modules/cloudsql"

  project_id       = var.project_id
  instance_name    = "${var.environment}-app-a-postgres"
  region           = var.region
  database_type    = "POSTGRES"
  database_version = "POSTGRES_15"

  availability_type      = "REGIONAL"
  disk_size              = 100
  private_network        = module.network.vpc_self_link
  private_vpc_connection = module.network.private_vpc_connection

  databases = ["app_a_db"]
  users = [
    {
      name     = "app_a_user"
      password = var.postgres_password
    }
  ]

  labels = {
    environment = var.environment
    application = "app-a"
  }

  depends_on = [module.network]
}

# Cloud SQL - SQL Server for Application B
module "cloudsql_sqlserver" {
  source = "../../modules/cloudsql"

  project_id       = var.project_id
  instance_name    = "${var.environment}-app-b-sqlserver"
  region           = var.region
  database_type    = "SQLSERVER"
  database_version = "SQLSERVER_2019_STANDARD"

  availability_type      = "REGIONAL"
  disk_size              = 100
  private_network        = module.network.vpc_self_link
  private_vpc_connection = module.network.private_vpc_connection

  users = [
    {
      name     = "app_b_user"
      password = var.sqlserver_password
    }
  ]

  labels = {
    environment = var.environment
    application = "app-b"
  }

  depends_on = [module.network]
}

# Compute - Application A (Linux)
module "compute_app_a" {
  source = "../../modules/compute"

  project_id   = var.project_id
  name         = "${var.environment}-app-a"
  region       = var.region
  zones        = var.zones
  machine_type = "n2-standard-2"

  source_image = var.app_a_image
  network      = module.network.vpc_self_link
  subnetwork   = module.network.subnets["${var.environment}-subnet-01"].self_link

  service_account_email = module.iam.service_account_emails["app-a-compute"]

  network_tags = ["allow-ssh", "allow-http-https", "allow-health-check"]

  target_size       = 2
  named_port_name   = "http"
  named_port        = 8080
  health_check_port = 8080
  health_check_path = "/health"

  labels = {
    environment = var.environment
    application = "app-a"
  }

  depends_on = [module.network, module.iam]
}

# Compute - Application B (Windows)
module "compute_app_b" {
  source = "../../modules/compute"

  project_id   = var.project_id
  name         = "${var.environment}-app-b"
  region       = var.region
  zones        = var.zones
  machine_type = "n2-standard-2"

  source_image = var.app_b_image
  network      = module.network.vpc_self_link
  subnetwork   = module.network.subnets["${var.environment}-subnet-01"].self_link

  service_account_email = module.iam.service_account_emails["app-b-compute"]

  network_tags = ["allow-rdp", "allow-http-https", "allow-health-check"]

  target_size       = 2
  named_port_name   = "http"
  named_port        = 80
  health_check_port = 80
  health_check_path = "/health"

  labels = {
    environment = var.environment
    application = "app-b"
  }

  depends_on = [module.network, module.iam]
}
