variable "cluster_name" {
  description = "The name to use to namespace all the resources in the cluster"
  type        = string
  default     = "webservers-cluster"
}

# Used in (data.tf) to give the remote state data source the name of the bucket
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

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
  type        = number
  default     = 5
}

variable "instance_type" {
  description = "The type of GCE Instances to run (e.g. t2.micro)"
  type        = string
  default     = "f1.micro"
}

variable "zone" {
  description = "The Zone for which the GCE instance will reside."
  type        = string
  default     = "us.central1-c"
}


variable "service_port" {
  description = "Port the service is listening on"
  type        = number
  default     = 80
}


variable "service_port_name" {
  description = "Name of the port the service is listening on"
  type        = string
  default     = "http"
}

variable "firewall_name" {
  description = "Name of the default firewall that will show up in the GCP console"
  type        = string
  default     = "flask-app-firewall"
}

variable "project_id" {
  description = "The project id of the current project as shown in GCP"
  type        = string
  default     = "flask-app-310119"
}


variable "service_account_display_name" {
  description = "The Service Account name displayed in GCP"
  type        = string
}

variable "service_account_description" {
  description = "Service account for webserver-cluster in flask app project dev environment"
  type        = string
}
