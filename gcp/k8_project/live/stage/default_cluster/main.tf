terraform {
  required_version = ">= 0.12"
}

# The google and google-beta provider blocks are used to configure the credentials you use to authenticate with GCP,
# as well as a default project and location (zone and/or region) for your resources.
provider "google" {}
//   project     = var.project_id
//   region      = var.region
//   credentials = file("credentials.json")
// }

// terraform {
//     backend "gcs" {
//         bucket      = "tf-core-state"
//         prefix      = "stage/cluster/terraform.tfstate"
//         credentials = "./credentials.json"
//     }
// }

resource "random_string" "password" {
  length = 16
  special = true
}


module "default_cluster" {
    source = "../../../modules/cluster"

    cluster_name          = "k8-cluster-project-gke-cluster-default"
    project_id            = var.project_id
    location              = var.location
    cluster_description   = "k8-cluster-project default Kubernetes cluster"
    node_pool_name        = var.node_pool_name
    username              = var.username
    password              = "${random_string.password.result}"
    machine_type          = "n1-standard-1"
    disk_size             = 50
    disk_type             = "pd-standard"
    image_type            = "COS"
    initial_node_count    = 1
    node_count            = 2
    auto_repair           = true
    auto_upgrade          = true
    gce_storage_disk_name = var.gce_storage_disk_name
    gce_storage_disk_size = "10GB"
}
