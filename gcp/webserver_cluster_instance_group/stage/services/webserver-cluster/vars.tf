variable "cluster_name" {
    description = "The name to use for all the cluster resources"
    type        = string
    default     = "flask-app-cluster"
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "flask-app-310119"
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

variable "db_remote_state_bucket" {
  description = "The name of the Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "db_remote_state_key" {
  description = "The name of the key in the Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-stores/cloudsql/terraform.tfstate"
}

variable "instance_type" {
  description = "The type of VM instance in GCE"
  type        = string
  default     = "t2.micro"
}
