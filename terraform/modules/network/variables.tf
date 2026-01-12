# Network Module Variables

variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "vpc_name" {
  description = "Name of the VPC network"
  type        = string
}

variable "subnets" {
  description = "List of subnets to create"
  type = list(object({
    name                        = string
    region                      = string
    ip_cidr_range               = string
    secondary_ip_range_pods     = string
    secondary_ip_range_services = string
  }))
}

variable "nat_regions" {
  description = "List of regions to create Cloud NAT in"
  type        = list(string)
  default     = []
}

variable "internal_ranges" {
  description = "Internal IP ranges for firewall rules"
  type        = list(string)
  default     = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
}

variable "ssh_source_ranges" {
  description = "Source IP ranges allowed for SSH"
  type        = list(string)
  default     = ["35.235.240.0/20"] # IAP range by default
}

variable "rdp_source_ranges" {
  description = "Source IP ranges allowed for RDP"
  type        = list(string)
  default     = ["35.235.240.0/20"] # IAP range by default
}
