variable "username" {
  description = "The username to use for HTTP basic authentication when accessing the Kubernetes master endpoint."
  type        = string
  default     = "k8-cluster-project"
}

// variable "service_account_display_name" {
//   description = "The Service Account name displayed in GCP"
//   type        = string
//   default     = "k8-cluster-project-cluster-sa"
// }

// variable "account_id" {
//   description = "The Service Account name displayed in GCP"
//   type        = string
//   default     = "k8-cluster-project-cluster-default-sa"
// }

variable "region" {
  description = "The region of the current project"
  type        = string
  default     = "us-central1"
}
