output "service_account_email" {
    description = "The e-mail address of the service account. This value should be referenced from any google_iam_policy data sources that would grant the service account privileges"
    value       = module.default_cluster.email
}

output "instance_group_urls" {
    description = "List of instance group URLs which have been assigned to the cluster"
    value       = module.default_cluster.instance_group_urls
}

output "cluster_self_link" {
    description = "The server-defined URL for the resource"
    value       = module.default_cluster.self_link
}

output "service_account_id" {
    description = "An identifier for the resource"
    value       = module.default_cluster.id
}

output "endpoint" {
    description = "The IP address of this cluster's Kubernetes master"
    value       = module.default_cluster.endpoint
}

output "services_ipv4_cidr" {
    description = "The IP address range of the Kubernetes services in this cluster, in CIDR notation (e.g. 1.2.3.4/29). Service addresses are typically put in the last /16 from the container CIDR"
    value       = module.default_cluster.services_ipv4_cidr
}

output k8s_context { value = "gke_${var.project_name}_${module.default_cluster.location}_${module.default_cluster.name}"}
