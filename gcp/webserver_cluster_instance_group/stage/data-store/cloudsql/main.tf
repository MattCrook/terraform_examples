variable project_name { default = "flask-app" }
variable namespace { default = "webserver_cluster" }


// resource "google_service_account_key" "sqlproxy_sa" {
//   service_account_id = data.terraform_remote_state.project.outputs.sqlproxy_sa
// }


# Creates a new Google SQL Database Instance.
resource "google_sql_database_instance" "postgres" {
  name             = var.db_name
  database_version = "POSTGRES_9_6"
  region           = "us-central1"
  project          = var.project_name

  replica_configuration {
    username = "admin"
    password = var.db_password
  }

  settings {
    tier = "db-f1-micro"
    availability_type  = "ZONAL"
    # For HA (High Availabilty) set this to Regional.
    # https://cloud.google.com/sql/docs/postgres/high-availability#normal
    // availability_type  = "REGIONAL"
    backup_configuration {
      enabled = true
    }
    maintenance_window {
      day = 2
      hour = 19
      update_track = "canary"
    }
    ip_configuration {
      ipv4_enabled = true
    }
  }
}

# Represents a SQL database inside the Cloud SQL instance, hosted in Google's cloud.
resource "google_sql_database" "database" {
  name      = "my-database"
  instance  = google_sql_database_instance.postgres.name
  charset   = "UTF8"
  collation = "en_US.UTF8"
  project   = var.project_name
}


# Creates a new Google SQL User on a Google SQL User Instance.
// resource "random_id" "db_name_suffix" {
//   byte_length = 4
// }

// resource "google_sql_database_instance" "master" {
//   name = "master-instance-${random_id.db_name_suffix.hex}"

//   settings {
//     tier = "db-f1-micro"
//   }
// }

// resource "google_sql_user" "users" {
//   name     = "me"
//   instance = google_sql_database_instance.master.name
//   host     = "me.com"
//   password = "changeme"
// }
