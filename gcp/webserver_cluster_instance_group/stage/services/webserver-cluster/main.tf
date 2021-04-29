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

resource "google_compute_network" "flask-app-vpc-network" {
  name                    = "vpc-network"
  auto-create-subnetworks = true
  project                 = var.project_id
  routing_mode            = "REGIONAL"
  mtu                     = 1500
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

variable project_name { default = "flask-app" }

resource "google_compute_firewall" "firewall-ssh-builder-access-router" {
  project   = "${var.project_id}"
  name      = "flask-app-ssh-builder-access-router"
  network   = "${google_compute_network.flask-app-vpc-network.name}"
  priority  = "1000"
  direction = "INGRESS"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }

  source_ranges           = ["0.0.0.0/0"]
  target_service_accounts = ["${module.webserver_cluster.service_account.email}"]
}

# Allow SA service account use the default GCE account
resource "google_service_account_iam_member" "gce-default-account-iam" {
  service_account_id = data.google_compute_default_service_account.default.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${module.webserver_cluster.service_account.name}"
}


// resource "google_service_account_iam_member" "admin-account-iam" {
//   service_account_id = "${module.webserver_cluster.service_account.email}"
//   role               = "roles/iam.serviceAccountUser"
//   member             = "user:jane@example.com"
// }
