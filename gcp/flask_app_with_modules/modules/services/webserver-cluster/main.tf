terraform {
  required_version = ">= 0.12"
}



resource "random_id" "instance_id" {
  byte_length = 8
}

resource "google_service_account" "flask_app_sa" {
  account_id   = "flask-app-sa-${random_id.instance_id.hex}"
  display_name = var.service_account_display_name
  project      = var.project_id
  description  = var.service_account_description
}

resource "google_service_account_iam_binding" "iam-binding" {
  service_account_id = google_service_account.flask_app_sa.email
  role               = var.role
  members            = var.members
}

# Represents an Autoscaler resource.
# Autoscalers allow you to automatically scale virtual machine instances in managed instance groups
# according to an autoscaling policy that you define.
# Equivalent to asg (auto scaling group) resource in aws.
# Using this to create/manage a cluster of VM's instead of creating a single instance.
resource "google_compute_autoscaler" "autoscaling_group" {
  name   = "my-autoscaling-group"
  zone   = var.zone
  target = google_compute_instance_group_manager.instance_group_manager.id

  autoscaling_policy {
    max_replicas    = var.max_replicas
    min_replicas    = var.min_replicas
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}

# Manages a VM instance template resource within GCE. To use "google_compute_autoscaler" use this to launch a cluster of VM's instead of creating a single VM.
# Equivalent to launch configuration resource in aws.
# Takes care of launching a cluster of instances, monitoring health, replacing failed instances, and ajusting size of cluster in response to load.
resource "google_compute_instance_template" "my_instance" {
  name        = "my_instance_template"
  description = "This template is used to create app server instances"

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  labels = {
    environment = "dev"
  }

  instance_description = "description assigned to VM instances"
  machine_type         = var.instance_type
  can_ip_forward       = false

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
  }

  boot_disk {
    initialize_params {
      image             = "debian-cloud/debian-9"
      auto_delete       = true
      boot              = true
      # backup the disk every day
      resource_policies = [google_compute_resource_policy.daily_backup.id]
    }
  }

  metadata = {
    ssh-keys = "matt.crook11@gmail.com:${file("~/.ssh/id_rsa.pub")}"
  }

  # Make sure flask is installed on all new instances for later steps
  metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

  network_interface {
    network = "default"

    access_config {
      # Include this section to give the VM an external ip address
    }
  }

  lifecycle {
    create_before_destroy = true
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}


resource "google_compute_target_pool" "target_pool" {
  name = "my-target-pool"
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/healthz"
    port         = "8080"
  }
}

# Creates and manages pools of homogeneous Compute Engine virtual machine instances from a common instance template.
resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "my-instance-igm"
  base_instance_name = "instance-group-manager"
  zone               = var.zone
  instance_template  = "${google_compute_instance_template.my_instance.self_link}"
  target_pools       = ["${google_compute_target_pool.target_pool.self_link}"]
  target_size        = 2
  # prevent any of the managed instances from being restarted by Terraform
  update_strategy    = "NONE"
  service_port       = var.service_port
  service_port_name  = var.service_port_name

  named_port {
    name = "customHTTP"
    port = 8888
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}


# resource policy used in google_compute_instance_template
resource "google_compute_resource_policy" "daily_backup" {
  name   = "every-day-4am"
  region = "us-central1"
  snapshot_schedule_policy {
    schedule {
      daily_schedule {
        days_in_cycle = 1
        start_time    = "04:00"
      }
    }
  }
}
