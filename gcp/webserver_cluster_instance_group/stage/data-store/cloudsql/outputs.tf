output "cloud_sql_self_link" {
    value       = google_sql_database_instance.postgres.self_link
    description = "The self-link of the postgres db instance"
}

output "cloud_sql_service_account_email_address" {
    value       = google_sql_database_instance.postgres.service_account_email_address
    description = "The service_account_email_address of the postgres db instance"
}

output "cloud_sql_ipv4_address" {
    value       = google_sql_database_instance.postgres.ip_address.0.ip_address
    description = "The IPv4 address assigned"
}

output "cloud_sql_public_ip_address" {
    value       = google_sql_database_instance.postgres.public_ip_address
    description = " The first public (PRIMARY) IPv4 address assigned. "
}
