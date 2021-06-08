variable "db_password" {
    description = "The password for the database"
    type        = string
}

variable "db_name" {
    description = "The name for the database"
    type        = string
}

variable "environment" {
    description = "The environment that the module or resource is in. Ex) stage, prod etc..."
    type        = string
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
}

variable "region" {
  description = "The region of the current project"
  type        = string
}

variable "zone" {
  description = "The zone of the current project"
  type        = string
}

variable "deletion_protection" {
  description = "Whether or not to allow Terraform to destroy the instance"
  type        = bool
}

// variable "env" {
//   description = "The Environment for which the context of resouce should be created in"
//   type        = string
// }

variable "user_labels" {
  description = "Custom labels to set on the mysql db instance"
  type        = map(string)
  default     = {
    "env" = "staging"
    }
}

variable db_version { default = "MYSQL_8_0" }
variable disk_size { default = "725" }
variable disk_type { default = "PD_SSD" }
variable disk_autoresize { default = true }
variable instance_type {default = "db-f1-micro"}
