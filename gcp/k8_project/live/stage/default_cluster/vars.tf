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

variable "machine_type" {
  description = "The ID of the project in GCP"
  type        = string
  # default     = "n1-standard-1"
  default     = "g1-small"
}

# The location (region or zone) in which the cluster master will be created, 
# as well as the default node location. If you specify a zone (such as us-central1-a), 
# the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), 
# the cluster will be a regional cluster with multiple masters spread across zones in the region, 
# and with default node locations in those zones as well
variable "location" {
  description = "The location (region or zone) in which the cluster master will be created"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "k8-cluster-project-gke-cluster-default"
}

variable "node_pool_name" {
  description = "The name of the cluster"
  type        = string
  default     = "cluster-project"
}
