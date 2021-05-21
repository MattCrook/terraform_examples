output "address" {
  value = "${google_sql_database_instance.example.ip_address.0.ip_address}"
}

output "db_instance_self_link" {
    value       = google_sql_database_instance.mysql_db_instance.self_link
    description = "The The URI of the created resource"
}

output "db_self_link" {
    value       = google_sql_database.mysql_db.self_link
    description = "The The URI of the created resource"
}
