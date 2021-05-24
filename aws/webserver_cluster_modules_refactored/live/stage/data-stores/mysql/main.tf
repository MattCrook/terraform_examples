provider "aws" {
  region = "us-east-2"
}

terraform {
    backend "s3" {
        bucket         = "tf-up-and-running-state-mc"
        key            = "stage/data-store/mysql/terraform.tfstate"
        region         = "us-east-2"
        dynamodb_table = "tf-up-and-running-locks"
        encrypt        = true
    }
}

module "mysql" {
  source = "../../../../modules/data-stores/mysql"

  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password
}
