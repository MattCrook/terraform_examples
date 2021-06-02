variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "project_id" {
  description = "The ID of the project in GCP"
  type        = string
  default     = "k8-cluster-project"
}

variable "cluster_description" {
  description = "The description of the google_container_cluster"
  type        = string
}

# The location (region or zone) in which the cluster master will be created, 
# as well as the default node location. If you specify a zone (such as us-central1-a), 
# the cluster will be a zonal cluster with a single cluster master. If you specify a region (such as us-west1), 
# the cluster will be a regional cluster with multiple masters spread across zones in the region, 
# and with default node locations in those zones as well
variable "location" {
  description = "The location (region or zone) in which the cluster master will be created"
  type        = string
}

variable "node_count" {
  description = "The number of nodes in the node pool"
  type        = number
}

variable "machine_type" {
  description = "Type of VM the node should run on"
  type        = string
}

variable "auto_repair" {
  description = "Whether the nodes will be automatically repaired"
  type        = bool
}

variable "auto_upgrade" {
  description = "Whether the nodes will be automatically upgraded"
  type        = bool
}

// variable "min_node_count" {
//   description = "Minimum number of nodes in the NodePool"
//   type        = number
//   default     = 1
// }

// variable "max_node_count" {
//   description = "Maximum number of nodes in the NodePool"
//   type        = number
//   default     = 3
// }

variable "disk_size" {
  description = "Size of the disk attached to each node, specified in GB"
  type        = number
}

variable "disk_type" {
  description = "Type of the disk attached to each node"
  type        = string
}

variable "image_type" {
  description = "The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool"
  type        = string
}

variable "username" {
  description = "The password to use for HTTP basic authentication when accessing the Kubernetes master endpoint"
  type        = string
}

variable "password" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint. If not present basic auth will be disabled"
  type        = string
}

variable "account_id" {
  description = "The Service Account name displayed in GCP"
  type        = string
  default     = "cluster-sa"
}

variable "display_name" {
  description = "The Service Account name displayed in GCP"
  type        = string
  default     ="k8-cluster-project-cluster-sa"
}

variable "service_account_description" {
  description = "Service account description for k8-cluster-poject in project"
  type        = string
  default     = "k8-cluster-project default Kubernetes cluster"
}

variable "master_version" {
  description = "K8 version"
  type        = string
  default     = "latest"
  // default     = "1.18.18-gke.1700"
}

variable "logging_service" {
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "initial_node_count" {
  description = "The initial number of nodes for the pool. In regional or multi-zonal clusters, this is the number of nodes per zone"
  type        = string
}

variable "node_pool_name" {
  description = "The name of the cluster"
  type        = string
}
