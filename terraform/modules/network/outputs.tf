# Network Module Outputs

output "vpc_id" {
  description = "VPC network ID"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "VPC network name"
  value       = google_compute_network.vpc.name
}

output "vpc_self_link" {
  description = "VPC network self link"
  value       = google_compute_network.vpc.self_link
}

output "subnets" {
  description = "Map of subnet names to subnet details"
  value = {
    for name, subnet in google_compute_subnetwork.subnets : name => {
      id            = subnet.id
      name          = subnet.name
      region        = subnet.region
      ip_cidr_range = subnet.ip_cidr_range
      self_link     = subnet.self_link
    }
  }
}

output "private_vpc_connection" {
  description = "Private VPC connection for Cloud SQL"
  value       = google_service_networking_connection.private_vpc_connection.id
}

output "router_ids" {
  description = "Map of region to router ID"
  value = {
    for region, router in google_compute_router.router : region => router.id
  }
}
