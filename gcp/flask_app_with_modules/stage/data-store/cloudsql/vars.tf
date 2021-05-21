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

variable "project_name" {
  description = "The name the current project"
  type        = string
  default     = "flask-app"
}

variable db_version { default = "POSTGRES_9_6" }
variable disk_size { default = "725" }
variable disk_type { default = "PD_SSD" }
variable disk_autoresize { default = true }
variable instance_type {default = "db-f1-micro"}
