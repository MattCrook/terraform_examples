output "service_account_id" {
    description = "The resource URLs of the managed instance groups associated with this node pool"
    value = google_container_node_pool.default_node_pool.instance_group_urls
}

output k8s_context { value = "gke_${var.project_name}_${google_container_cluster.default.location}_${google_container_cluster.default.name}"}
