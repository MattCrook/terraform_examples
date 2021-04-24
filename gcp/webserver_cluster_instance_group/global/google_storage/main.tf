# Our gcs bucket to store the state. Will use "gcs" as backend which is this bucket.
resource "google_storage_bucket" "core-state" {
    name          = var.bucket_name
    storage_class = "STANDARD"
    location      = var.location
    project       = var.project_id
    # This is only here so we can destroy the bucket as part of automated tests. You should not copy this for production usage.
    // force_destroy = true
    versioning {
        enabled = true
    }

    lifecycle_rule {
      condition {
        age = 3
    }
      action {
        type = "SetStorageClass"
        storage_class = "STANDARD"
      }
   }
}

# Relational database google offers fully managed relational database service designed
# to offer both strong consistency and horizontal scalability for mission-critical online transaction processing (OLTP) applications.
// resource "google_spanner_instance" "tf-locks" {
//   config       = "regional-us-central1"
//   display_name = var.table_name
//   num_nodes    = 1
//   labels = {
//     "name" = "terraform-locks"
//   }
// }
