# Required variable
variable "db_password" {
  description = "The password for the database"
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# OPTIONAL PARAMETERS
# These parameters have reasonable defaults.
# ---------------------------------------------------------------------------------------------------------------------


variable "db_name" {
  description = "The name to use for the database"
  type        = string
  default     = "example_mysql_db_stage"
}

variable "db_username" {
  description = "The username for the database"
  type        = string
  default     = "admin"
}
