terraform {
  required_version = ">= 0.12, < 0.13"
}

provider "aws" {
  region = "us-east-2"
}

terraform {
    backend "s3" {
        bucket         = "tf-up-and-running-state-mc"
        key            = "stage/services/terraform.tfstate"
        region         = "us-east-2"
        dynamodb_table = "tf-up-and-running-locks-mc"
        encrypt        = true
    }
}

resource "aws_db_instance" "example" {
  identifier_prefix   = "terraform-up-and-running-mc"
  engine              = "mysql"
  allocated_storage   = 10
  instance_class      = "db.t2.micro"
  name                = var.db_name
  username            = "admin"
  password            = var.db_password
  skip_final_snapshot = true
}
