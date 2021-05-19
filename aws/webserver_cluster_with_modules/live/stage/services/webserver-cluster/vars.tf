variable "db_remote_state_bucket" {
  description = "The name of the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "db_remote_state_key" {
  description = "The name of the key in the S3 bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-store/mysql/terraform.tfstate"
}

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-stage"
}

# Boolean input variable that we can use to specify wheather the module should enable auto-scaling
# Way to conditionally create auto-scaling for some users but not for others.
variable "enable_autoscaling" {
  description = "If set to true, enable auto scaling"
  type        = bool
}
