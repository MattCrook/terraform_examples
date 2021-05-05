output "cloud_storage_bucket_resource_self_link" {
    value       = google_storage_bucket.tf_state.self_link
    description = "The URI of the created resource"
}

output "bucket_url" {
    description = "Bucket URL (for single use)"
    value       = google_storage_bucket.tf_state.url
}

// output "iam_member_etag" {
//   description = "The etag of the project's IAM policy"
//   value       = google_project_iam_member.webserver_iam_editor.etag
// }

output "project-service-ids" {
    description = "The etag of the project's IAM policy"
    value       = values(google_project_service.extra-webserver-cluster-services)[*].id
}

output "google_storage_sa" {
    description = "The email of the service account for Google Cloud Storge bucket"
    value       = google_service_account.google_storage_sa.email
}

output "google_storage_sa_name" {
    description = "The fully-qualified name of the service account for Google Cloud Storge bucket"
    value       = google_service_account.google_storage_sa.name
}

output "google_storage_sa_private_key" {
    description = "The private key in JSON format, base64 encoded. This is what you normally get as a file when creating service account keys through the CLI or web console. "
    value       = google_service_account_key.google_storage_sa_key.private_key
    sensitive   = true
}

output "google_storage_sa_public_key" {
    description = "The public key, base64 encoded"
    value       = google_service_account_key.google_storage_sa_key.public_key
}
