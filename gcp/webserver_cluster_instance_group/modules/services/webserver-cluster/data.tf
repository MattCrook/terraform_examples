data "terraform_remote_state" "db" {
    backend = "gcs"

    config = {
        bucket = var.db_remote_state_bucket
        key    = var.db_remote_state_key
        region = "us-central1"
    }
}


data "google_compute_image" "debian_9" {
  family  = "debian-9"
  project = var.project_id
}
