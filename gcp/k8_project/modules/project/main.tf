terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "random_id" "project_id" {
  byte_length = 8
}


resource "google_project" "project" {
  name       = "${var.project_name}-${random_id.project_id.hex}"
  project_id = var.project_id
}


resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

module "k8-admin-sa" {
    display_name = var.service_account_display_name
    description  = var.service_account_description
    role         = var.role
    members      = var.members
}


output "project_id" {
  value = google_project.project.project_id
}
