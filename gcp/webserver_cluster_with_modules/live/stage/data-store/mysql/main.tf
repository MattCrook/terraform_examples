provider "google" {
    project     = var.project_id
    region      = var.region
    zone        = var.zone
    credentials = file("credentials.json")
}

terraform {
    backend "gcs" {
        bucket      = "tf-up-and-running-state-mc"
        prefix      = "stage/data-store/mysql/terraform.tfstate"
        credentials = "./credentials.json"
    }
}


resource "google_sql_database_instance" "mysql_db_instance" {
  region = "us-central1"
  settings {
    tier = "db-f1-micro"
    disk_size = "10"
  }
}


resource "google_sql_database" "mysql_db" {
  name       = var.db_name
  instance   = "${google_sql_database_instance.example.name}"
  # I experienced problems when "google_sql_user" runs in parallel
  depends_on = ["google_sql_user.admin"]
}


resource "google_sql_user" "admin" {
  name     = "admin"
  instance = "${google_sql_database_instance.example.name}"
  host     = "1.2.3.4"
  password = "${var.db_password}" 
}
