variable "db_password" {
  description = "The password for the database"
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "terraform-up-and-running-mc"
}

variable "bucket_name" {
  description = "The name of the gcs bucket. Must be globally unique."
  type        = string
  default     = "tf-up-and-running-state-mc"
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

variable "db_name" {
  description = "The name of the MySql Database"
  type        = string
  default     = "example_mysql_database"
}
