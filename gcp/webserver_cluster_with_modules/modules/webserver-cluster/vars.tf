variable "server_port" {
  description = "The port the server will use for HTTP requests"
  type        = number
  default     = 8080
}


variable "cluster_name" {
  description = "The name to use for all the cluster resources"
}


variable "db_remote_state_bucket" {
  description = "The name of the Google Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "tf-up-and-running-state-mc"
}


variable "db_remote_state_key" {
  description = "The name of the key in the Google Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-store/mysql/terraform.tfstate"
}


variable "instance_type" {
  description = "The type of Google Compute Engine Instances to run (e.g. f1-micro)"
}


variable "min_replicas" {
  description = "The minimum number of Google Compute Engine Instances in the Autoscaler"
  type        = number
  default     = 2
}


variable "max_replicas" {
  description = "The maximum number of Google Compute Engine Instances in the Autoscaler"
  type        = number
  default     = 10
}
