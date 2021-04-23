# Creates a database in RDS. Amazon's Relational Database Service.

resource "aws_db_instance" "example_rds" {
    identifier_prefix = "tf-up-and-running-mc"
    engine            = "mysql"
    allocated_storage = 10
    instance_class    = "db.t2.micro"
    name              = var.db_name
    username          = "admin"
    password          = var.db_password
    # password          = data.aws_secretsmanager_secret_version.db_password.secret_string
}
