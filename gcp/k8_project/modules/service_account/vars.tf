variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "k8-cluster-project"
}


variable "account_id" {
  description = "The Service Account ID"
  type        = string
}

variable "display_name" {
  description = "The Service Account name displayed in GCP"
  type        = string
}

variable "service_account_description" {
  description = "Service account for k8-cluster-poject in project"
  type        = string
}

// variable "role" {
//   description = "Service account role"
//   type        = string
//      default = "roles/container.admin"
// }

// variable "members" {
//   description = "Service account list of members"
//   type        = list
//   default     = []
// }
