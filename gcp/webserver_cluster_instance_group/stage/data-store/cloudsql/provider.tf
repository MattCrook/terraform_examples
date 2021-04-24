provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("credentials.json")
}

# Configure this module to store its state in the GCS bucket created in main.tf in webserver-cluster.
terraform {
    backend "gcs" {
        bucket      = "tf-state-mc"
        prefix      = "stage/data-stores/cloudsql/terraform.tfstate"
        credentials = "./credentials.json"
    }
}
