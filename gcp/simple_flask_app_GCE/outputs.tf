// A variable for extracting the external IP address of the instance
// Run terraform apply followed by terraform output ip to return the instance's external IP address.
output "ip" {
    description = "Acts as a helper to expose the instance's ip address."
    value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}
