output "cloud_storage_bucket_resource_self_link" {
    value       = google_storage_bucket.tf_state.self_link
    description = "The URI of the created resource"
}

output "bucket_url" {
  description = "Bucket URL (for single use)"
  value       = google_storage_bucket.core-state.url
}
