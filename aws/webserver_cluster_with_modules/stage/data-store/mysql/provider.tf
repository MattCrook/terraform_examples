provider "aws" {
    region = "us-east-2"
}

# Configure this module to store its state in the S3 bucket created in main.tf in webserver-cluster.
terraform {
    backend "s3" {
        bucket         = "tf-up-and-running-state-mc"
        key            = "stage/data-stores/mysql/terraform.tfstate"
        region         = "us-east-2"
        dynamodb_table = "tf-up-and-running-locks"
        encrypt        = true
    }
}
