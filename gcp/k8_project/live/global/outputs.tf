output "storage_bucket_self_link" {
  value = "${google_storage_bucket.terraform_state.self_link}"
}

output "state_bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.tf_state
}

output "logging_bucket" {
  description = "The created storage bucket"
  value       = google_storage_bucket.logging_bucket
}
