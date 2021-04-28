resource "aws_iam_user" "example_iam" {
    # Every TF resource has a meta-parameter called count. Simple Iteration contruct, simply defines
    # how many copis of the resouce to create.
    # Access count.index (like arr[i]) to give each name or iteration a different name.
    # count = 3
    # name  = "Brave${count.index}"

    # This is a better way, saying count is the length of the array "user_names"
    # and name is each index of the array at variable "user_names"
    # count = length(var.user_names)
    # name  = var.user_names[count.index]

    # using for_each -- covert to set because for_each only supports sets and maps when used on a resource.
    # Access each value of current item in loop with each.value.
    # After terraorm plan, this will output the keys and values, the keys being the keys in for_each (names) and the values being the outputs for that resource.
    for_each = toset(var.user_names)
    name     = each.value
}

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

resource "aws_dynamodb_table" "terraform_locks" {
    name            = var.table_name
    billing_mode    = "PAY_PER_REQUEST"
    hash_key        = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}
