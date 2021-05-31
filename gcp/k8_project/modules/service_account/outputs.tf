output "service_account_email" {
    description = "The e-mail address of the service account. This value should be referenced from any google_iam_policy data sources that would grant the service account privileges"
    value       = google_service_account.serviceaccount.email
}

output "service_account_id" {
    description = "An identifier for the resource"
    value       = google_service_account.serviceaccount.id
}
