variable "db_password" {
    description = "The password for the database"
    type        = string
    default     = module.mysql.db_password
}

variable "db_name" {
    description = "The name for the database"
    type        = string
    default     = "k8-project-db-master"
}

variable "environment" {
    description = "The environment that the module or resource is in. Ex) stage, prod etc..."
    type        = string
    default     = "stage"
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "k8-cluster-project"
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

variable "project_name" {
  description = "The name the current project"
  type        = string
  default     = "k8-cluster-project"
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance"
  type        = bool
  default     = false
}
