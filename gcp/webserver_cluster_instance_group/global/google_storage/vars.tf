variable "bucket_name" {
  description = "The name of the gcs bucket. Must be globally unique."
  type        = string
  default     = "tf-state-mc"
}

variable "table_name" {
  description = "The name of the Google Cloud Spanner table. Must be unique in this AWS account."
  type        = string
  default     = "tf-locks-mc"
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

variable "storage_class" {
  description = "Bucket storage class."
  type        = string
  default     = "REGIONAL"
}

variable "location" {
  description = "Bucket location."
  type        = string
  default     = "US"
}

variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-prod"
}
