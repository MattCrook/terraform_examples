variable "project_name" {
    description = "The name to use for the project"
    type        = string
    default     = "k8-cluster-project"
}

variable "project_id" {
    description = "The name to use for the project"
    type        = string
    default     = "k8-cluster-project"
}

variable "service_account_display_name" {
  description = "The Service Account name displayed in GCP"
  type        = string
  default     = "k8-cluster-admin-sa"
}

variable "service_account_description" {
  description = "Service account for k8-cluster-poject in project"
  type        = string
  default     = "Admin service account for k8 cluster"
}

variable "role" {
  description = "Service account role"
  type        = string
}

variable "members" {
  description = "Service account list of members"
  type        = list
}
