output "managed_instance_group_name" {
    description = "Name of the Managed Instance Group"
    value = google_compute_instance_group_manager.instance_group_manager.name
}

output "managed_instance_group_link" {
    description = "Link to the instance_group property of the instance group manager resource"
    value = google_compute_instance_group_manager.instance_group_manager.instance_group
}

output "managed_instance_group_target_tags" {
    description = "Pass through of input target_tags"
    value = google_compute_instance_group_manager.instance_group_manager.target_tags
}

output "managed_instance_group_service_port" {
    description = "Pass through of input service_port"
    value = google_compute_instance_group_manager.instance_group_manager.service_port
}

output "managed_instance_group_service_port_name" {
    description = "Pass through of input service_port_name"
    value = google_compute_instance_group_manager.instance_group_manager.service_port_name
}

output "managed_instance_group_service_depends_id" {
    description = "Id of the dummy dependency created used for intra-module dependency creation"
    value = google_compute_instance_group_manager.instance_group_manager.depends_id
}

output "managed_instance_group_service_network_ip" {
    description = "Pass through of input network_ip"
    value = google_compute_instance_group_manager.instance_group_manager.network_ip
}

output "compute_autoscaler_self_link" {
    description = "The URI of the created resource"
    value = google_compute_autoscaler.autoscaling_group.self_link
}

output "service_account_email" {
    description = "The e-mail address of the service account. This value should be referenced from any google_iam_policy data sources that would grant the service account privileges"
    value = google_service_account.flask_app_sa.email
}

output "service_account_id" {
    description = "an identifier for the resource"
    value = google_service_account.flask_app_sa.id
}
