output "service_account_email" {
    description = "The e-mail address of the service account. This value should be referenced from any google_iam_policy data sources that would grant the service account privileges"
    value       = module.default_cluster.service_account_email
}

output "instance_group_urls" {
    description = "List of instance group URLs which have been assigned to the cluster"
    value       = module.default_cluster.instance_group_urls
}

output "cluster_self_link" {
    description = "The server-defined URL for the resource"
    value       = module.default_cluster.cluster_self_link
}

output "service_account_id" {
    description = "An identifier for the resource"
    value       = module.default_cluster.service_account_id
}

output "endpoint" {
    description = "The IP address of this cluster's Kubernetes master"
    value       = module.default_cluster.endpoint
}

output "services_ipv4_cidr" {
    description = "The IP address range of the Kubernetes services in this cluster, in CIDR notation (e.g. 1.2.3.4/29). Service addresses are typically put in the last /16 from the container CIDR"
    value       = module.default_cluster.services_ipv4_cidr
}

output "certificate" {
  value       = module.default_cluster.certificate
  sensitive   = true
}

output "client_certificate" {
  value       = module.default_cluster.client_certificate
  sensitive   = true
}

output "client_key" {
  value       = module.default_cluster.client_key
  sensitive   = true
}

output "master_version" {
  value = module.default_cluster.master_version
}

output "password" {
  description = "The password to use for HTTP basic authentication when accessing the Kubernetes master endpoint"
  sensitive   = true
  value       = "${module.default_cluster.password.result}"
}

output "creation_timestamp" {
  description = "Creation timestamp in RFC3339 text format"
  value     = module.default_cluster.creation_timestamp
}

output "gce_storage_disk_self_link" {
  description = "The URI of the created resource"
  value     = module.default_cluster.gce_storage_disk_self_link
}

output "source_image_id" {
  description = "The ID value of the image used to create this disk"
  value     = module.default_cluster.source_image_id
}

output k8s_context { value = "gke_${var.project_id}_${var.location}_${var.cluster_name}"}
