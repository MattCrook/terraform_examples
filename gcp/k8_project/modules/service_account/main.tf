terraform {
  required_version = ">= 0.12"
}

resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_service_account" "sa" {
  account_id   = "k8-project-sa-${random_id.instance_id.hex}"
  display_name = var.service_account_display_name
  project      = var.project_id
  description  = var.service_account_description
}

resource "google_service_account_iam_binding" "iam-binding" {
  service_account_id = google_service_account.sa.email
  role               = var.role
  members            = var.members
}
