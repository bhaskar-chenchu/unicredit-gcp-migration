# Compute Module Outputs

output "instance_template_id" {
  description = "Instance template ID"
  value       = google_compute_instance_template.template.id
}

output "instance_template_self_link" {
  description = "Instance template self link"
  value       = google_compute_instance_template.template.self_link
}

output "instance_group_id" {
  description = "Instance group manager ID"
  value       = google_compute_region_instance_group_manager.mig.id
}

output "instance_group_self_link" {
  description = "Instance group manager self link"
  value       = google_compute_region_instance_group_manager.mig.self_link
}

output "instance_group" {
  description = "Instance group URL for load balancer backend"
  value       = google_compute_region_instance_group_manager.mig.instance_group
}

output "health_check_id" {
  description = "Health check ID"
  value       = google_compute_health_check.health_check.id
}

output "health_check_self_link" {
  description = "Health check self link"
  value       = google_compute_health_check.health_check.self_link
}
