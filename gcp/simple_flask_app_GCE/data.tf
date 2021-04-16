// Local backend
data "terraform_remote_state" "vpc" {
  backend = "local"

  config {
    path = "../network/terraform.tfstate"
  }
}

// Remote backend
data "terraform_remote_state" "vpc" {
    backend = "s3"
    config {
        bucket  = "networking-terraform-state-files"
        key     = "vpc-prod01.terraform.tfstate"
        region  = "us-east-1"
    }
}
