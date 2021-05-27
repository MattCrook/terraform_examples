variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "k8-cluster-project"
}


variable "service_account_display_name" {
  description = "The Service Account name displayed in GCP"
  type        = string
}

variable "service_account_description" {
  description = "Service account for k8-cluster-poject in project"
  type        = string
}

variable "role" {
  description = "Service account role"
  type        = string
}

variable "members" {
  description = "Service account list of members"
  type        = list
}
