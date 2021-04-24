output "cloud_storage_bucket_resource_self_link" {
    value       = google_storage_bucket.core-state.self_link
    description = "The URI of the created resource"
}

// output "cloud_spanner_table_name" {
//     value       = google_spanner_instance.tf-locks.name
//     description = "The name of the Cloud Spanner table."
// }

// output "bucket_url" {
//   description = "Bucket URL (for single use)"
//   value       = google_storage_bucket.core-state.url
// }
