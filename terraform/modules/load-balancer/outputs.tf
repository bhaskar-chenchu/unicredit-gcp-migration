# Load Balancer Module Outputs

output "external_ip" {
  description = "External IP address"
  value       = google_compute_global_address.lb_ip.address
}

output "backend_service_id" {
  description = "Backend service ID"
  value       = google_compute_backend_service.backend.id
}

output "url_map_id" {
  description = "URL map ID"
  value       = google_compute_url_map.url_map.id
}

output "https_proxy_id" {
  description = "HTTPS proxy ID"
  value       = google_compute_target_https_proxy.https_proxy.id
}

output "managed_certificate_id" {
  description = "Managed SSL certificate ID"
  value       = var.create_managed_certificate ? google_compute_managed_ssl_certificate.certificate[0].id : null
}
