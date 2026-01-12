# Terratest Fixture for Network Module

module "network" {
  source = "../../../../terraform/modules/network"

  project_id          = var.project_id
  region              = var.region
  environment         = var.environment
  vpc_name            = var.vpc_name
  public_subnet_cidr  = var.public_subnet_cidr
  private_subnet_cidr = var.private_subnet_cidr
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

variable "vpc_name" {
  type    = string
  default = "test-vpc"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "enable_ssh_firewall" {
  type    = bool
  default = true
}

variable "enable_http_firewall" {
  type    = bool
  default = true
}

output "vpc_id" {
  value = module.network.vpc_id
}

output "vpc_name" {
  value = module.network.vpc_name
}
