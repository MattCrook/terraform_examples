variable "username" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint."
  type        = string
  default     = "k8-cluster-project-username"
}

// variable "password" {
//   description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint. If not present basic auth will be disabled"
//   type        = string
//   default     = "${random_string.password.result}"
// }

variable "project_id" {
  description = "The ID of the project in GCP"
  type        = string
  default     = "k8-cluster-project"
}

variable "region" {
  description = "The region of the project in GCP"
  type        = string
  default     = "us-central1"
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

variable "gce_storage_disk_name" {
  description = "The name of the GCEPersistantDisk"
  type        = string
  default     = "mongodb"
}

variable "min_node_count" {
  description = "Minimum number of nodes in the NodePool"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes in the NodePool"
  type        = number
  default     = 3
}
