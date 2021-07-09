output "instance_group_urls" {
    description = "The resource URLs of the managed instance groups associated with this node pool"
    value       = google_container_node_pool.default_node_pool.instance_group_urls
}

output "service_account_id" {
    description = "An identifier for the resource"
    value       = module.k8_cluster_sa.service_account_id
}

output "service_account_email" {
    description = "The email for the service account created"
    value       = module.k8_cluster_sa.service_account_email
}

output "cluster_self_link" {
    description = "The server-defined URL for the resource"
    value       = google_container_cluster.default.self_link
}

output "endpoint" {
    description = "The IP address of this cluster's Kubernetes master"
    value       = google_container_cluster.default.endpoint
}

output "services_ipv4_cidr" {
    description = "The IP address range of the Kubernetes services in this cluster, in CIDR notation (e.g. 1.2.3.4/29). Service addresses are typically put in the last /16 from the container CIDR"
    value       = google_container_cluster.default.services_ipv4_cidr
}

output "certificate" {
  value       = google_container_cluster.default.master_auth.0.cluster_ca_certificate
  sensitive   = true
}

output "client_certificate" {
  value     = google_container_cluster.default.master_auth.0.client_certificate
  sensitive = true
}

output "client_key" {
  value     = google_container_cluster.default.master_auth.0.client_key
  sensitive = true
}

output "master_version" {
  value = google_container_cluster.default.master_version
}

output "creation_timestamp" {
  description = "Creation timestamp in RFC3339 text format"
  value       = google_compute_disk.gce_persistant_disk.creation_timestamp
}

output "gce_storage_disk_self_link" {
  description = "The URI of the created resource"
  value       = google_compute_disk.gce_persistant_disk.self_link
}

output "source_image_id" {
  description = "The ID value of the image used to create this disk"
  value       = google_compute_disk.gce_persistant_disk.source_image_id
}

output k8s_context { value = "gke-${var.project_id}_${google_container_cluster.default.location}"}
