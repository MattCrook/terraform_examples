terraform {
  required_version = ">= 0.12"
}


resource "random_id" "instance_id" {
  byte_length = 8
}


module "k8_cluster_sa" {
  source      = "../service_account/main.tf"
  account_id   = "${var.service_account_display_name}"
  display_name = var.service_account_display_name
  account_id   = "k8-cluster-sa"
  display_name = "k8-cluster-sa"
  project      = var.project_id
  description  = var.service_account_description
}


resource "google_container_cluster" "default" {
  name        = var.cluster_name
  project     = var.project_id
  description = var.cluster_description
  location    = var.region

  # By default, creating a cluster creates a default node pool as it requires one to be created, we are removing this node as we are ceating our own resource below.
  remove_default_node_pool = true
  initial_node_count       = 1

  master_auth {
    username = var.username
    password = var.password

    client_certificate_config {
      issue_client_certificate = false
    }
  }

  node_config {
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
    image_type   = var.image_type
    machine_type = var.instance_type
  }
}


resource "google_container_node_pool" "default_node_pool" {
  name       = "${var.cluster_name}-node-pool"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.default.name
  node_count = var.node_count

  management {
    auto_repair = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  # Specifies number of nodes according to load, should not be used along side node_count
  // auto_scaling {
  //   min_node_count = var.min_node_count
  //   max_node_count = var.max_node_count
  // }

  node_config {
    preemptible  = true
    machine_type = var.machine_type

    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # OAuthScopes - The set of Google API scopes to be made available on all of the node VMs under the "default" service account. 
    # Use the "https://www.googleapis.com/auth/cloud-platform" scope to grant access to all APIs. It is recommended that you set service_account to a non-default service account and grant IAM roles to that service account for only the resources that it needs
    service_account = module.k8_cluster_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}