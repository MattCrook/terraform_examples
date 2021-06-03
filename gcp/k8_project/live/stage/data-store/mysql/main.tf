terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("credentials.json")
}

# Configure this module to store its state in the GCS bucket created in main.tf in webserver-cluster.
// terraform {
//     backend "gcs" {
//         bucket      = "tf-up-and-running-state-mc"
//         prefix      = "stage/data-stores/cloudsql/terraform.tfstate"
//         credentials = "./credentials.json"
//     }
// }

module "mysql" {
    project_id          = var.project_id
    db_name             = var.db_name
    environment         = var.environment
    region              = var.region
    zone                = var.zone
    deletion_protection = var.deletion_protection
}

# Represents a SQL database inside the Cloud SQL instance, hosted in Google's cloud.
resource "google_sql_database" "k8-project-stage" {
  name      = "k8-project-stage"
  instance  = module.mysql.name
  charset   = "UTF8"
  collation = "en_US.UTF8"
  project = var.project_name
}

# Used for PostgreSql. Because Cloud SQL for PostgreSQL is a managed service,
# it restricts access to certain system procedures and tables that require advanced privileges.
// resource "google_sql_user" "k8-project-user" {
//   name     = "k8-project"
//   instance = module.mysql.name
//   password = module.mysql.db_password
//   project = var.project_name
// }
