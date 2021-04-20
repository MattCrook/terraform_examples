# Creates a database in RDS. Amazon's Relational Database Service.
resource "aws_db_instance" "example_rds" {
    identifier_prefix = "tf-up-and-running-mc"
    engine            = "mysql"
    allocated_storage = 10
    instance_class    = "db.t2.micro"
    name              = "example_database"
    username          = "root"
    # Two options for password. Use a secrets store and use data source,
    # or manage outside of TF and pass them in as variables.
    # password          = data.aws_secretsmanager_secret_version.db_password.secret_string
    password          = var.db_password

}
