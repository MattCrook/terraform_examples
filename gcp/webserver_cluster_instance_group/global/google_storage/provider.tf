provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("credentials.json")
}


terraform {
    backend "gcs" {
        bucket      = "tf-state-mc"
        prefix      = "global/google_storage/terraform.tfstate"
        credentials = "./credentials.json"
    }
}
