provider "google" {
    project     = var.project_id
    region      = var.region
    zone        = var.zone
    credentials = file("credentials.json")
}

terraform {
    backend "gcs" {
        bucket      = "tf-up-and-running-state-mc"
        prefix      = "stage/services/webserver-cluster/terraform.tfstate"
        credentials = "./credentials.json"
    }
}

module "webserver_cluster" {
  source = "../../../../modules/webserver-cluster"

  cluster_name           = var.cluster_name
  db_remote_state_bucket = var.db_remote_state_bucket
  db_remote_state_key    = var.db_remote_state_key

  instance_type     = "f1-micro"
  min_replicas      = 2
  max_replicas      = 2
}


resource "google_compute_firewall" "allow_inbound_testing" {
  name    = "allow-inbound-testing"
  network = "default"

  source_ranges = ["0.0.0.0/0"]

  allow {
    protocol = "tcp"
    ports    = [12346]
  }
}
