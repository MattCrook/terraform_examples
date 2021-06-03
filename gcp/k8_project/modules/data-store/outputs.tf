output "name" {
    description = "The name of the database instance"
    value       = google_sql_database_instance.mysql.name
}

output "connection_name" {
    description = "The connection name of the instance to be used in connection strings"
    value       = google_sql_database_instance.mysql.connection_name
}

output "ipv4" {
    description = "The IPv4 address assigned."
    value       = google_sql_database_instance.mysql.ip_address.0.ip_address
}

output "db_password" {
  sensitive = true
  value = "${random_string.password.result}"
}

output "self_link" {
    description = "The URI of the created resource"
    value       = google_sql_database_instance.mysql.self_link
}
