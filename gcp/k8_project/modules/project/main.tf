terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
  region      = var.region
}

resource "random_id" "project_id" {
  byte_length = 4
}


resource "google_project" "project" {
  name       = var.project_name
  project_id = "${var.project_id}-${random_id.project_id.hex}"
}


resource "google_project_service" "service" {
  for_each = toset([
    "compute.googleapis.com",
    "container.googleapis.com",
    "iam.googleapis.com",
    "sqladmin.googleapis.com",
    "serviceusage.googleapis.com"
  ])

  service = each.key

  project            = google_project.project.project_id
  disable_on_destroy = false
}

output "project" {
  value = google_project.project.project_id
}

output "google_project_service" {
  value = google_project_service.service.id
}
