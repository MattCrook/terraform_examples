terraform {
  required_version = ">= 0.12"
}

# Creates a new Google SQL Database Instance (Currently configured for PostgreSql).
resource "google_sql_database_instance" "mysql" {
    project             = var.project_id
    name                = "${var.db_name}-${var.environment}"
    region              = var.region
    database_version    = var.db_version
    deletion_protection = var.deletion_protection

    lifecycle {
        ignore_changes = [settings.0.replication_type]
    }
    settings {
        tier                           = var.instance_type
        authorized_gae_applications    = []
        crash_safe_replication         = false
        disk_autoresize                = var.disk_autoresize
        availability_type              = "REGIONAL"
        disk_type                      = var.disk_type
        pricing_plan                   = "PER_USE"
        user_labels = {
            "env" = "dev"
        }
        ip_configuration {
            ipv4_enabled = true
            require_ssl = false
        }
        backup_configuration {
            enabled = true
            location = "us"
            point_in_time_recovery_enabled = true
            start_time = "03:00"
        }
        location_preference {
            zone = var.zone
        }
        maintenance_window {
            day = 7
            hour = 4
            update_track = "stable"
        }
    }
    timeouts {}
}

resource "random_string" "password" {
  length = 16
  special = true
}
