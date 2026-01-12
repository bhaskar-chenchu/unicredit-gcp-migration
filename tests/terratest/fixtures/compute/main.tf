# Terratest Fixture for Compute Module

module "compute" {
  source = "../../../../terraform/modules/compute"

  project_id       = var.project_id
  region           = var.region
  environment      = var.environment
  instance_name    = var.instance_name
  machine_type     = var.machine_type
  instance_type    = var.instance_type
  source_image     = var.source_image
  network          = var.network
  subnetwork       = var.subnetwork
  min_replicas     = var.min_replicas
  max_replicas     = var.max_replicas
  assign_public_ip = var.assign_public_ip
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

variable "instance_name" {
  type    = string
  default = "test-instance"
}

variable "machine_type" {
  type    = string
  default = "e2-medium"
}

variable "instance_type" {
  type    = string
  default = "linux"
}

variable "source_image" {
  type    = string
  default = "projects/rocky-linux-cloud/global/images/family/rocky-linux-9"
}

variable "network" {
  type    = string
  default = "default"
}

variable "subnetwork" {
  type    = string
  default = "default"
}

variable "min_replicas" {
  type    = number
  default = 1
}

variable "max_replicas" {
  type    = number
  default = 3
}

variable "assign_public_ip" {
  type    = bool
  default = false
}
