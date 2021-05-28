terraform {
  required_version = ">= 0.12"
}


provider "google" {
  project     = var.project_id
  region      = var.region
//   zone        = var.zone
//   credentials = file("credentials.json")
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

    name                        = "k8-cluster-project-gke-cluster-default"
    project                     = "k8-cluster-project"
    // service_account_description = "k8-cluster-project default Kubernetes cluster"
    location                    = "us-central1"
    username                    = var.username
    password                    = "${random_string.password.result}"
    disk_size_gb                = 50
    disk_type                   = "pd-standard"
    image_type                  = "COS"
    node_count                  = 3
    auto_repair                 = true
    auto_upgrade                = true
    // display_name                = var.account_id
    // account_id                  = var.account_id
}
