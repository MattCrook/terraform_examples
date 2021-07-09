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

variable "min_node_count" {
  description = "Minimum number of nodes in the NodePool"
  type        = number
}

variable "max_node_count" {
  description = "Maximum number of nodes in the NodePool"
  type        = number
}

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

variable "enable_vertical_pod_autoscaling" {
  type        = bool
  default     = false
}

variable "release_channel" {
  type        = string
  default     = "STABLE"
}

variable "gce_storage_disk_name" {
  description = "Name of the resource. Provided by the client when the resource is created"
  type        = string
}

variable "gce_storage_disk_type" {
  description = "URL of the disk type resource describing which disk type to use to create the disk. Provide this when creating the disk"
  type        = string
  default     = "pd-ssd"
}

variable "gce_storage_disk_size" {
  description = "Size of the persistent disk, specified in GB"
  type        = number
}

variable "environments" {
    type = map
    default = {
        "environment"  = "stage"
    }
}



# Optional in google_compute_disk resource.
// variable "gce_storage_disk_image" {
//   description = "The image from which to initialize this disk"
//   type        = string
//   default     = "debian-9-stretch-v20200805"
// }
