terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("credentials.json")
}

# Configure this module to store its state in the GCS bucket created in main.tf in webserver-cluster.
terraform {
    backend "gcs" {
        bucket      = "tf-up-and-running-state-mc"
        prefix      = "stage/services/webserver-cluster/terraform.tfstate"
        credentials = "./credentials.json"
    }
}

# To use a module, basicaly like "calling a function"
# Using the module defined in /modules/services/webserver-cluster
# Really didn't have to fill in these vars, the use of a module is so that we can use
# the same logic, but pass in different values.
module "webserver_cluster" {
  source = "../../../modules/services/webserver-cluster"

  project_id             = var.project_id
  region                 = var.region
  zone                   = var.zone
  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key
  instance_type          = var.instance_type
  display_name           = var.service_account_display_name
  description            = var.service_account_description
}


# Google Cloud allows for opening ports to traffic via firewall policies, which can also be managed in Terraform configuration.
# You can now point the browser to the instance's IP address and port 5000 and see the server running.
resource "google_compute_firewall" "default" {
  name          = var.firewall_name
  network       = "default"
  project       = var.project_id
  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = ["5000", "80"]
  }
}
