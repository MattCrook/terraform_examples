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
  name               = var.cluster_name
  project            = var.project_id
  description        = var.cluster_description
  location           = var.location
  min_master_version = var.master_version
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service
  initial_node_count = var.initial_node_count
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

  # List of node pools associated with this cluster
  // node_pool {
  //   name               = "default-pool"
  //   initial_node_count = var.initial_node_count
  // }

  labels {
    environment = "stage"
  }

  # By default, creating a cluster creates a default node pool as it requires one to be created,
  # we are removing this node as we are ceating our own resource below.
  remove_default_node_pool = true
}


resource "google_container_node_pool" "default_node_pool" {
  // for_each = local.node_pools
  // name     = each.key
  name               = "${var.node_pool_name}-node-pool"
  project            = var.project_id
  location           = var.location
  cluster            = google_container_cluster.default.name
  node_count         = var.node_count
  # initial_node_count = var.initial_node_count

   # use node_locations if provided, defaults to cluster level node_locations if not specified
   # The list of zones in which the node pool's nodes should be located. Nodes must be in the region of their regional cluster or in the same region as their cluster's zone for zonal clusters. 
   # If unspecified, the cluster-level node_locations will be used.
  // node_locations = lookup(each.value, "node_locations", "") != "" ? split(",", each.value["node_locations"]) : null

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
    preemptible  = false
    machine_type = var.machine_type
    disk_size_gb = var.disk_size
    disk_type    = var.disk_type
    image_type   = var.image_type


    metadata = {
      disable-legacy-endpoints = "true"
      metadata_startup_script = 
    }

    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    # OAuthScopes - The set of Google API scopes to be made available on all of the node VMs under the "default" service account. 
    # Use the "https://www.googleapis.com/auth/cloud-platform" scope to grant access to all APIs. It is recommended that you set service_account to a non-default service account and grant IAM roles to that service account for only the resources that it needs
    # "https://www.googleapis.com/auth/logging.write",
    # "https://www.googleapis.com/auth/monitoring",
    # "https://www.googleapis.com/auth/cloud-platform"
    service_account = module.k8_cluster_sa.service_account_email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  lifecycle {
    ignore_changes = [initial_node_count]
  }
}

# GCE Persistant Disk to attach PV's and PVC' to.
# Persistent disks are located independently from your virtual machine instances, so you can detach or move persistent disks to keep your data even after you delete your instances.
resource "google_compute_disk" "gce_persistant_disk" {
  name  = var.gce_storage_disk_name
  type  = var.gce_storage_disk_type
  zone  = google_container_cluster.default.location
  size  = var.gce_storage_disk_size
  # Image optional
  # image = "debian-9-stretch-v20200805"
  labels = {
    environment = "stage"
  }
  physical_block_size_bytes = 4096
}
