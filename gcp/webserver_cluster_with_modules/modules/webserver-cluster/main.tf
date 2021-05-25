terraform {
  required_version = ">= 0.12"
}


locals {
  http_port    = 80
  any_port     = 0
  any_protocol = "-1"
  tcp_protocol = "tcp"
  all_ips      = ["0.0.0.0/0"]
}

resource "google_compute_address" "compute_address" {
    name = "${var.cluster_name}-address"
}


resource "google_compute_instance_template" "instance_template" {
  machine_type   = "${var.instance_type}"

  disk {
    source_image = "ubuntu-1604-lts"
  }

  network_interface {
    network = "default"
    #access_config {
    #  // Ephemeral IP
    #}
  }

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = var.cluster_name
    propagate_at_launch = true
  }

  labels = {
    environment = "stage"
  }

  metadata_startup_script = "${data.template_file.user_data.rendered}"
}


resource "google_compute_forwarding_rule" "compute_forwarding_rule" {
  name       = "${var.cluster_name}-forwarding-rule"
  target     = "${google_compute_target_pool.compute_target_pool.self_link}"
  port_range = "8080"
  ip_address = "${google_compute_address.compute_address.address}"
}


resource "google_compute_target_pool" "compute_target_pool" {
  name = "${var.cluster_name}-example-target-pool"
  health_checks = ["${google_compute_http_health_check.compute_health_check.name}"]
}

# Manages a VM instance template resource within GCE. To use "google_compute_autoscaler" use this to launch a cluster of VM's instead of creating a single VM.
# Equivalent to launch configuration resource in aws.
# Takes care of launching a cluster of instances, monitoring health, replacing failed instances, and ajusting size of cluster in response to load.
resource "google_compute_instance_group_manager" "instance_group_manager" {
  name               = "${var.cluster_name}-example-group-manager"
  description        = "This template is used to create app server instances"
  instance_template  = "${google_compute_instance_template.instance_template.self_link}"
  target_pools       = ["${google_compute_target_pool.compute_target_pool.self_link}"]
  base_instance_name = "${var.cluster_name}"

  auto_healing_policies {
    health_check      = google_compute_health_check.autohealing.id
    initial_delay_sec = 300
  }
}

# Represents an Autoscaler resource.
# Autoscalers allow you to automatically scale virtual machine instances in managed instance groups
# according to an autoscaling policy that you define.
# Equivalent to asg (auto scaling group) resource in aws.
# Using this to create/manage a cluster of VM's instead of creating a single instance.
resource "google_compute_autoscaler" "autoscaling_group" {
  name   = "${var.cluster_name}-autoscaler"
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

resource "google_compute_backend_service" "backend" {
  name = "${var.cluster_name}-backend-service"
  port_name = "http"
  protocol = "HTTP"
  timeout_sec = 10
  enable_cdn = false

  backend {
    group = "${google_compute_instance_group_manager.instance_group_manager.instance_group}"
  }

  health_checks = ["${google_compute_http_health_check.compute_health_check.self_link}"]
}


resource "google_compute_http_health_check" "compute_health_check" {
  name                 = "${var.cluster_name}-health-check"
  request_path         = "/"
  check_interval_sec   = 30
  timeout_sec          = 3
  healthy_threshold    = 2
  unhealthy_threshold  = 2
  port                 = "${var.server_port}"
}


resource "google_compute_firewall" "instance" {
  name    = "${var.cluster_name}-firewall-instance"
  network = "default"

  source_ranges = locals.all_ips

  allow {
    protocol = locals.tcp_protocol
    ports    = ["${var.server_port}"]
  }
}

resource "google_compute_health_check" "autohealing" {
  name                = "autohealing-health-check"
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = "/health"
    port         = "8080"
  }
}
