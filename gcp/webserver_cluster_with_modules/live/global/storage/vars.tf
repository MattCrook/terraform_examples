variable "bucket_name" {
  description = "The name of the gcs bucket. Must be globally unique."
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "terraform-up-and-running-mc"
}

variable "region" {
  description = "The region of the current project"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "The zone of the current project"
  type        = string
  default     = "us-central1-c"
}

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-prod"
}

variable "encryption_key_names" {
  description = "Optional map of lowercase unprefixed name => string, empty strings are ignored."
  type        = map(string)
  default     = {}
}

# For remote state data source
variable "db_remote_state_bucket" {
  description = "The name of the Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "tf-state-mc"
}

variable "db_remote_state_key" {
  description = "The name of the key in the Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-stores/cloudsql/terraform.tfstate"
}
