output "name" {
    description = "The name of the database instance"
    value       = module.mysql.name
}

output "connection_name" {
    description = "The connection name of the instance to be used in connection strings"
    value       = module.mysql.connection_name
}

output "ipv4" {
    description = "The IPv4 address assigned."
    value       = module.mysql.ipv4
}

output "db_password" {
  sensitive = true
  value     = module.mysql.db_password
}

output "self_link" {
    description = "The URI of the created resource"
    value       = module.mysql.self_link
}
