terraform {
  required_version = ">= 0.12"
}


provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("credentials.json")
}

// terraform {
//     backend "gcs" {
//         bucket      = "tf-core-state"
//         prefix      = "stage/cluster/terraform.tfstate"
//         credentials = "./credentials.json"
//     }
// }


module "default_cluster" {
    source = "../../../modules/cluster/main.tf"

    name            = var.cluster_name
    project         = var.project_id
    description     = var.cluster_description
    location        = var.region
    username        = var.username
    password        = var.password
    disk_size_gb    = var.disk_size
    disk_type       = var.disk_type
    image_type      = var.image_type
    machine_type    = var.instance_type
    node_count      = var.node_count
    auto_repair     = var.auto_repair
    auto_upgrade    = var.auto_upgrade
    machine_type    = var.machine_type
    service_account = module.k8_cluster_sa.email
}
