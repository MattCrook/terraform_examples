variable "bucket_name" {
  description = "The name of the gcs bucket. Must be globally unique."
  type        = string
  default     = "tf-up-and-running-state-mc"
}

variable "table_name" {
  description = "The name of the Google Cloud Spanner table. Must be unique in this AWS account."
  type        = string
  default     = "tf-up-and-running-locks"
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

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-prod"
}

variable "encryption_key_names" {
  description = "Optional map of lowercase unprefixed name => string, empty strings are ignored."
  type        = map(string)
  default     = {}
}

variable "enable_apis" {
  default     = "true"
}

variable "default_apis" {
  type        = list(string)
  default = []
}

variable "extra_apis" {
  type        = list(string)
  default = [
    "cloudresourcemanager.googleapis.com",
    "iam.googleapis.com",
    "serviceusage.googleapis.com",
    "iamcredentials.googleapis.com"
    ]
}

variable "disable_services_on_destroy" {
  default     = "true"
  type        = string
}

variable "disable_dependent_services" {
  default     = "true"
  type        = string
}

# For remote state data source
variable "db_remote_state_bucket" {
  description = "The name of the Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "tf-state-mc"
}

variable "db_remote_state_key" {
  description = "The name of the key in the Cloud Storage bucket used for the database's remote state storage"
  type        = string
  default     = "stage/data-stores/cloudsql/terraform.tfstate"
}
