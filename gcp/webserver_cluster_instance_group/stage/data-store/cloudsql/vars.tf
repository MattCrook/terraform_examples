variable "db_password" {
    description = "The password for the database"
    type        = string
}

variable "db_name" {
    description = "The name for the database"
    type        = string
    default     = "webserver-master-db"
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
