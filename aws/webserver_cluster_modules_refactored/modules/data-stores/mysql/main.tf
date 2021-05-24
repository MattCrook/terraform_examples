terraform {
  required_version = ">= 0.12"
}

# Creates a database in RDS. Amazon's Relational Database Service.
resource "aws_db_instance" "example_rds" {
    identifier_prefix   = "tf-up-and-running-mc"
    engine              = "mysql"
    allocated_storage   = 10
    instance_class      = "db.t2.micro"
    name                = var.db_name
    username            = "admin"
    password            = var.db_password
    skip_final_snapshot = true
}
