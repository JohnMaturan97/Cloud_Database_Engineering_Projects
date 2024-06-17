resource "google_project_service" "cloud_resource_manager_api" {
  service = "cloudresourcemanager.googleapis.com"
}

resource "google_project_service" "cloud_sql_admin_api" {
  service = "sqladmin.googleapis.com"
  depends_on = [
    google_project_service.cloud_resource_manager_api
  ]
}

resource "google_sql_database_instance" "production_postgres" {
  name             = var.instance_name
  region           = var.region
  database_version = "POSTGRES_14"
  deletion_protection = true

  settings {
    tier = "db-f1-micro"
    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
    ip_configuration {
      ipv4_enabled = true
    }
    disk_size = "10"
  }

  depends_on = [
    google_project_service.cloud_sql_admin_api
  ]
}

resource "google_sql_database" "primary_db" {
  name     = var.database_name
  instance = google_sql_database_instance.production_postgres.name
  depends_on = [
    google_project_service.cloud_sql_admin_api
  ]
}

resource "google_sql_user" "database_admin" {
  name     = var.user_name
  instance = google_sql_database_instance.production_postgres.name
  password = var.user_password
  depends_on = [
    google_project_service.cloud_sql_admin_api
  ]
}
