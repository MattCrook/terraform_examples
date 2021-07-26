terraform {
  required_version = ">= 0.12"
}


# Configure cluster to use a Google Service Account.
# This will allow Terraform to authenticate to Google Cloud without having to bake in a separate credential/authentication file.
# Ensure that the scope of the VM/Cluster is set to or includes https://www.googleapis.com/auth/cloud-platform.
module "k8_cluster_sa" {
  source                       = "../service_account"
  account_id                   = var.account_id
  display_name                 = var.display_name
  project_id                   = var.project_id
  service_account_description  = var.service_account_description
}

resource "google_container_cluster" "default" {
  name                     = var.cluster_name
  project                  = var.project_id
  description              = var.cluster_description
  location                 = var.location
  min_master_version       = var.master_version
  logging_service          = var.logging_service
  monitoring_service       = var.monitoring_service
  initial_node_count       = var.initial_node_count
  remove_default_node_pool = true
  # network            =
  # subnetwork         =

  release_channel {
    channel = var.release_channel
  }

  vertical_pod_autoscaling {
    enabled = var.enable_vertical_pod_autoscaling
  }

  # If this block is provided and both username and password are empty, basic authentication will be disabled.
  master_auth {
    username = ""
    password = ""

    client_certificate_config {
      issue_client_certificate = false
    }
  }
}


resource "google_container_node_pool" "default_node_pool" {
  name               = "${var.node_pool_name}-node-pool"
  project            = var.project_id
  location           = var.location
  cluster            = google_container_cluster.default.name
  node_count         = var.node_count

  management {
    auto_repair  = var.auto_repair
    auto_upgrade = var.auto_upgrade
  }

  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  node_config {
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
    image_type   = var.image_type


    metadata = {
      disable-legacy-endpoints = "true"
      metadata_startup_script = data.template_file.startup_script.rendered
    }

    service_account = module.k8_cluster_sa.service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

resource "google_compute_disk" "gce_persistant_disk" {
  project = var.project_id
  name    = var.gce_storage_disk_name
  type    = var.gce_storage_disk_type
  zone    = google_container_cluster.default.location
  size    = var.gce_storage_disk_size

  labels = {
    environment = "stage"
  }
  physical_block_size_bytes = 4096
}
