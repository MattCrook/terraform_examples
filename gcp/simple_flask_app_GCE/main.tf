// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
  byte_length = 8
}

// A single Compute Engine instance
resource "google_compute_instance" "default" {
  name         = "flask-app-vm-${random_id.instance_id.hex}"
  machine_type = "f1-micro"
  zone         = "us-central1-c"

  metadata = {
    ssh-keys = "matt.crook11@gmail.com:${file("~/.ssh/id_rsa.pub")}
  }

 // Can run <gcloud compute images list> to se full list of public images
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      // Include this section to give the VM an external ip address
    }
  }
}

// Google Cloud allows for opening ports to traffic via firewall policies, which can also be managed in Terraform configuration.
// You can now point the browser to the instance's IP address and port 5000 and see the server running.
resource "google_compute_firewall" "default" {
  name    = "flask-app-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["5000"]
  }
}
