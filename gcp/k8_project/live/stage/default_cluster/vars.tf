variable "username" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint."
  type        = string
  default     = "k8-cluster-project-username"
}

variable "project_id" {
  description = "The ID of the project in GCP"
  type        = string
  default     = "k8-cluster-project"
}

variable "region" {
  description = "The region of the project"
  type        = string
  default     = "us-central1"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "k8-cluster-project-gke-cluster-default"
}
