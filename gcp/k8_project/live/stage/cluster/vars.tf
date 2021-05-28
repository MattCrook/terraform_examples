variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
  default     = "k8-cluster-project-gke-cluster-default"
}

variable "project_id" {
  description = "The ID of the project in GCP"
  type        = string
  default     = "k8-cluster-project"
}

variable "cluster_description" {
  description = "The description of the google_container_cluster"
  type        = string
  default     = "k8-cluster-project default Kubernetes cluster"
}

variable "region" {
  description = "The region of the project"
  type        = string
  default     = "us-central1"
}

variable "node_pool_region" {
  description = "The region of the node pool"
  type        = string
  default     = "us-central1"
}

variable "node_count" {
  description = "The number of nodes in the node pool"
  type        = number
  default     = 3
}

variable "machine_type" {
  default = "n1-standard-1"
}

variable "auto_repair" {
  description = "Whether the nodes will be automatically repaired"
  type        = boolean
  default     = true
}

variable "auto_upgrade" {
  description = "Whether the nodes will be automatically upgraded"
  type        = boolean
  default     = true
}

variable "disk_size" {
  description = "Size of the disk attached to each node, specified in GB"
  type        = number
  default     = 50
}

variable "disk_type" {
  description = "Type of the disk attached to each node"
  type        = string
  default     = "pd-standard"
}

variable "image_type" {
  description = "The image type to use for this node. Note that changing the image type will delete and recreate all nodes in the node pool"
  type        = string
  default     = "COS"
}

variable "instance_type" {
  description = "The name of a Google Compute Engine machine type"
  type        = string
  default     = "n1-standard-8"
}

variable "username" {
  description = "The password to use for HTTP basic authentication when accessing the Kubernetes master endpoint"
  type        = string
}

variable "password" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint. If not present basic auth will be disabled"
  type        = string
}