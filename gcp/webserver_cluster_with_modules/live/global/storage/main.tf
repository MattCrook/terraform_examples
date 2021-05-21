provider "google" {
    project     = var.project_id
    region      = var.region
    zone        = var.zone
    credentials = file("credentials.json")
}

terraform {
    backend "gcs" {
        bucket      = "tf-up-and-running-state-mc"
        prefix      = "global/storage/terraform.tfstate"
        credentials = "./credentials.json"
    }
}

# Our gcs bucket to store the state. Will use "gcs" as backend which is this bucket.
resource "google_storage_bucket" "tf_state" {
    name          = var.bucket_name
    location      = "US"
    project       = var.project_id
    # This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production usage.
    force_destroy = true
    versioning {
        enabled = true
    }
}
