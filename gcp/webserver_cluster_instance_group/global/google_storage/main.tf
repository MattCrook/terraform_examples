provider "google" {
    project     = var.project_id
    region      = var.region
    zone        = var.zone
    credentials = file("credentials.json")
}

terraform {
    backend "gcs" {
        bucket      = "tf-up-and-running-state-mc"
        prefix      = "global/google_storage/terraform.tfstate"
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

    # Having a permanent encryption block with default_kms_key_name = "" works but results in terraform applying a change every run
    # There is no enabled = false attribute available to ask terraform to ignore the block
    // dynamic "encryption" {
    //   # If an encryption key name is set for this bucket name -> Create a single encryption block
    //   for_each = trimspace(lookup(var.encryption_key_names, lower(each.value), "")) != "" ? [true] : []
    //   content {
    //     default_kms_key_name = trimspace(
    //       lookup(
    //         var.encryption_key_names,
    //         lower(each.value),
    //         "Error retrieving kms key name", # Should be unreachable due to the for_each check
    //         # Omitting default is deprecated & can help show if there was a bug
    //         # https://www.terraform.io/docs/configuration/functions/lookup.html
    //       )
    //     )
    //   }
    // }
}

locals {
    api_set = var.enable_apis ? toset(var.default_apis) : []
    extra_api_set = var.enable_apis ? toset(var.extra_apis) : []
}


# Enabling a Google service / API with Terraform.
resource "google_project_service" "extra-webserver-cluster-services" {
    for_each                   = local.extra_api_set
    project                    = var.project_id
    service                    = each.value
    disable_on_destroy         = var.disable_services_on_destroy
    disable_dependent_services = var.disable_dependent_services
}


resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_service_account" "google_storage_sa" {
  account_id   = "google-storage-sa-${random_id.instance_id.hex}"
  display_name = "Google Storage Admin Service Account"
  project      = var.project_id
  description  = "Google Storage Bucket admin service account to view and edit resources"
}

resource "google_service_account_iam_binding" "google-storage-bucket-account-iam" {
  project = var.project_id
  role    = "roles/storage.admin"

  members = [
    "serviceAccount:${google_service_account.google_storage_sa.email}"
  ]
}
