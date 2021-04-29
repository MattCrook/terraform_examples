output "cloud_storage_bucket_resource_self_link" {
    value       = google_storage_bucket.tf_state.self_link
    description = "The URI of the created resource"
}

output "bucket_url" {
  description = "Bucket URL (for single use)"
  value       = google_storage_bucket.tf_state.url
}

output "iam_member_etag" {
  description = "The etag of the project's IAM policy"
  value       = google_project_iam_member.webserver_iam_editor.etag
}

output "project-service-id" {
  description = "The etag of the project's IAM policy"
  value       = google_project_service.extra-webserver-cluster-services[*]
}
