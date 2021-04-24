variable "cluster_name" {
    description = "The name to use for all the cluster resources"
    type        = string
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  defualt     = "flask-app-310119"
}

variable "region" {
  description = "The region of the current project"
  type        = string
  defualt     = "us-central1"
}

variable "zone" {
  description = "The zone of the current project"
  type        = string
  defualt     = "us-central1-c"
}

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
