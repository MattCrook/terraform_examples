provider "aws" {
  region = "us-east-2"
}

# Terraform will automatically pull the latest from this S3 bucket before running a command, and
# automatically push the latest state to the S3 bucket after running a command.


// terraform {
//     backend "s3" {
//         # bucket name from below, name of bucket we want to use
//         bucket         = "tf-up-and-running-state-mc"
//         # File path within the S3 bucket where the tfstate file should be written.
//         # the key attribute is where you want to store the state file.
//         key            = "global/s3/terraform.tfstate"
//         region         = "us-east-2"

//         # dynamodb table name from below
//         dynamodb_table = "tf-up-and-running-locks"
//         # Srtting this to true ensures the tfstate will be encrypted on disk when stored in S3.
//         # We already enabled default encryption on the bucket itself, so this is here as a second layer of protection.
//         encrypt        = true
//     }
// }
