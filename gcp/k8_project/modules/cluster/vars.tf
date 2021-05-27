variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "k8-cluster-project-gke-cluster-primary"
}

variable "region" {
  description = "The region of the project"
  type        = string
  default     = "us-central1"
}

variable "node_pool_name" {
  description = "The name of the node pool"
  type        = string
  default     = "k8-project-node-pool"
}

variable "node_pool_region" {
  description = "The region of the node pool"
  type        = string
  default     = "us-central1"
}
