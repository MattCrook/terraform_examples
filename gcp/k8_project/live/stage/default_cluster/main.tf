terraform {
  required_version = ">= 0.12"
}


provider "google" {
  project     = var.project_id
  region      = var.region
  // credentials = file("credentials.json")
}

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

    cluster_name        = "k8-cluster-project-gke-cluster-default"
    project_id          = var.project_id
    region              = var.region
    cluster_description = "k8-cluster-project default Kubernetes cluster"
    username            = var.username
    password            = "${random_string.password.result}"
    machine_type        = "n1-standard-1"
    disk_size           = 50
    disk_type           = "pd-standard"
    image_type          = "COS"
    node_count          = 3
    auto_repair         = true
    auto_upgrade        = true
}
