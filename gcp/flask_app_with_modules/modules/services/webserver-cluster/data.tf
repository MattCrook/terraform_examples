data "terraform_remote_state" "db" {
    backend = "gcs"

    config = {
        bucket = var.db_remote_state_bucket
        prefix = stage/data-store/cloudsql
    }
}


data "google_compute_image" "debian_9" {
  family  = "debian-9"
  project = var.project_id
}
