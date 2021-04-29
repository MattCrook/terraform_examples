output "vpc_gateway_ip" {
    description = "The gateway address for default routing out of the network. This value is selected by GCP"
    value = google_compute_network.flask-app-vpc-network.gateway_ipv4
}
