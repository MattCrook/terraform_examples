# S3 bucket to store the state file in.
resource "aws_s3_bucket" "tf_state" {
    bucket = var.bucket_name

    # prevent accidental deletion of this bucket, so terraform destroy wil exit in an error.
    # lifecycle {
    #     prevent_destroy = true
    # }

    # This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production usage.
    force_destroy = true

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

# DynamoBD tabe is AWS's distributed key value store, used for locking.
# Supports strongy conistant reads and conditional writes.  Need this to ensure you have a distributed lock system.
resource "aws_dynamodb_table" "terraform_locks" {
    name            = var.table_name
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
