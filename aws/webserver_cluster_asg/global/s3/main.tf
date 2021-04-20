provider "aws" {
  region = "us-east-2"
}

# Terraform will automatically pull the latest from this S3 bucket before running a command, and
# automatically push the latest state to the S3 bucket after running a command.

# Important gotcha: the "backend" block does not allow you to use any varibals or references.
terraform {
    backend "s3" {
        # bucket name from below, name of bucket we want to use
        bucket    = "tf-up-and-running-state-mc"
        # File path within the S3 bucket where the tfstate file should be written.
        # the key attribute is where you want to store the state file.
        key       = "global/s3/terraform.tfstate"
        region    = "us-east-2"

        # dynamodb table name from below
        dynamodb_table = "tf-up-and-running-locks"
        # Srtting this to true ensures the tfstate will be encrypted on disk when stored in S3.
        # We already enabled default encryption on the bucket itself, so this is here as a second layer of protection.
        encrypt       = true
    }
}

resource "aws_s3_bucket" "tf_state" {
    bucket = "tf-up-and-running-state-mc"

    # prevent accidental deletion of this bucket, so terraform destroy wil exit in an error.
    lifecycle {
        prevent_destroy = true
    }

    # Eneable versioning so we can see the full revision history of our state files.
    # Every update to the file in the bucket creates a new file.
    versioning {
        enabled = true
    }

    # Enable server-side encryption by default, ensures state files are always encrypted on disk when stored in S3.
    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

resource "aws_dynamodb_table" "terraform_locks" {
    name            = "tf-up-and-running-locks"
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
