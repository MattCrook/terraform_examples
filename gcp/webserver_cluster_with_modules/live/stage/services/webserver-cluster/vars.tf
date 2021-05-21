variable "db_remote_state_bucket" {
  description = "The name of the Google Storage Bucket used for the database's remote state storage"
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "db_remote_state_path" {
  description = "The name of the path in the Google Cloud Storage bucket used for the database's remote state storage"
  default     = "stage/data-stores/mysql/terraform.tfstate"
}

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-cluster-stage"
}

variable "instance_type" {
  description = "The type of machine to use for our VM instance"
  type        = string
  default     = "f1-micro"
}
