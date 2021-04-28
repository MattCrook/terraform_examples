output "address" {
    value       = aws_db_instance.example_rds.address
    description = "Connect to the database at this endpoint"
}

output "port" {
    value       = aws_db_instance.example_rds.port
    description = "The port the database is listening on"
}
