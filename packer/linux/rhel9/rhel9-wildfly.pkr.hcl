# Packer Template - RHEL 9 with WildFly 30+ and Java 17/21
# UniCredit GCP Migration

packer {
  required_plugins {
    googlecompute = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/googlecompute"
    }
    ansible = {
      version = ">= 1.1.0"
      source  = "github.com/hashicorp/ansible"
    }
  }
}

# Variables
variable "project_id" {
  type        = string
  description = "GCP Project ID"
}

variable "zone" {
  type        = string
  description = "GCP Zone for building the image"
  default     = "us-central1-a"
}

variable "source_image_family" {
  type        = string
  description = "Source image family"
  default     = "rhel-9"
}

variable "source_image_project" {
  type        = string
  description = "Source image project"
  default     = "rhel-cloud"
}

variable "machine_type" {
  type        = string
  description = "Machine type for building"
  default     = "n2-standard-2"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GB"
  default     = 50
}

variable "java_version" {
  type        = string
  description = "Java version (17 or 21)"
  default     = "17"
}

variable "wildfly_version" {
  type        = string
  description = "WildFly version"
  default     = "30.0.1.Final"
}

variable "image_name_prefix" {
  type        = string
  description = "Prefix for the image name"
  default     = "rhel9-wildfly"
}

variable "image_family" {
  type        = string
  description = "Image family for the created image"
  default     = "rhel9-wildfly"
}

variable "network" {
  type        = string
  description = "VPC network for building"
  default     = "default"
}

variable "subnetwork" {
  type        = string
  description = "Subnetwork for building"
  default     = "default"
}

# Locals
locals {
  timestamp  = formatdate("YYYYMMDDhhmmss", timestamp())
  image_name = "${var.image_name_prefix}-java${var.java_version}-${local.timestamp}"
}

# Source
source "googlecompute" "rhel9" {
  project_id              = var.project_id
  zone                    = var.zone
  source_image_family     = var.source_image_family
  source_image_project_id = var.source_image_project
  machine_type            = var.machine_type
  disk_size               = var.disk_size
  disk_type               = "pd-ssd"

  image_name        = local.image_name
  image_family      = var.image_family
  image_description = "RHEL 9 with WildFly ${var.wildfly_version} and OpenJDK ${var.java_version}"
  image_labels = {
    os              = "rhel9"
    java_version    = var.java_version
    wildfly_version = replace(var.wildfly_version, ".", "-")
    created_by      = "packer"
  }

  network     = var.network
  subnetwork  = var.subnetwork
  tags        = ["packer-build", "allow-ssh"]
  use_os_login = true

  ssh_username = "packer"

  metadata = {
    enable-oslogin = "TRUE"
  }
}

# Build
build {
  sources = ["source.googlecompute.rhel9"]

  # Update system
  provisioner "shell" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf install -y wget tar unzip vim"
    ]
  }

  # Install Java
  provisioner "shell" {
    inline = [
      "sudo dnf install -y java-${var.java_version}-openjdk java-${var.java_version}-openjdk-devel",
      "java -version",
      "echo 'JAVA_HOME=/usr/lib/jvm/java-${var.java_version}-openjdk' | sudo tee -a /etc/environment",
      "source /etc/environment"
    ]
  }

  # Install WildFly
  provisioner "shell" {
    inline = [
      "cd /opt",
      "sudo wget -q https://github.com/wildfly/wildfly/releases/download/${var.wildfly_version}/wildfly-${var.wildfly_version}.tar.gz",
      "sudo tar xzf wildfly-${var.wildfly_version}.tar.gz",
      "sudo mv wildfly-${var.wildfly_version} wildfly",
      "sudo rm wildfly-${var.wildfly_version}.tar.gz",
      "sudo groupadd -r wildfly",
      "sudo useradd -r -g wildfly -d /opt/wildfly -s /sbin/nologin wildfly",
      "sudo chown -R wildfly:wildfly /opt/wildfly"
    ]
  }

  # Configure WildFly systemd service
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /etc/wildfly",
      "sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.conf /etc/wildfly/",
      "sudo cp /opt/wildfly/docs/contrib/scripts/systemd/wildfly.service /etc/systemd/system/",
      "sudo cp /opt/wildfly/docs/contrib/scripts/systemd/launch.sh /opt/wildfly/bin/",
      "sudo chmod +x /opt/wildfly/bin/launch.sh",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable wildfly"
    ]
  }

  # Create deployment directories
  provisioner "shell" {
    inline = [
      "sudo mkdir -p /opt/wildfly/standalone/deployments",
      "sudo mkdir -p /var/log/wildfly",
      "sudo chown -R wildfly:wildfly /var/log/wildfly",
      "sudo mkdir -p /etc/wildfly/properties"
    ]
  }

  # Install PostgreSQL client
  provisioner "shell" {
    inline = [
      "sudo dnf install -y postgresql"
    ]
  }

  # Run Ansible for CIS hardening (optional, run via Ansible provisioner)
  # provisioner "ansible" {
  #   playbook_file = "../../../ansible/playbooks/linux-modern/cis-hardening.yml"
  # }

  # Clean up
  provisioner "shell" {
    inline = [
      "sudo dnf clean all",
      "sudo rm -rf /var/cache/dnf/*",
      "sudo rm -rf /tmp/*",
      "sudo rm -rf /var/tmp/*"
    ]
  }

  post-processor "manifest" {
    output     = "manifest.json"
    strip_path = true
  }
}
