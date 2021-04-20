# Provide the address and port of the database to the webserver-cluster.
# These outputs are also stored in the TF state for the database, which is in the S3 bucker at the path stage/data-stores/mysql/terraform.tfstate.
# We can get web server cluster code to read the data from this state file by adding the terraform_remote_state data source in data.tf in ./webserver-cluster.
output "address" {
    value       = aws_db_instance.example_rds.address
    description = "Connect to the database at this endpoint"
}

output "port" {
    value       = aws_db_instance.example_rds.port
    description = "The port the database is listening on"
}
