terraform {
  required_version = ">= 0.12"
}

// resource "random_id" "instance_id" {
//   byte_length = 4
// }

resource "google_service_account" "serviceaccount" {
  account_id   = var.account_id
  display_name = var.display_name
  project      = var.project_id
  description  = var.service_account_description
}

// resource "google_service_account_iam_binding" "get_credentials" {
//   service_account_id = module.k8_cluster_sa.service_account_id
//   role               = "roles/container.admin"
//   members            = ["serviceAccount:${module.k8_cluster_sa.service_account_email}"]
// }
