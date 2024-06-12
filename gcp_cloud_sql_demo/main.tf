resource "google_sql_database_instance" "postgres_instance" {
  name             = var.instance_name
  region           = var.region
  database_version = "POSTGRES_14"

  settings {
    tier = "db-f1-micro"
    
    backup_configuration {
      enabled    = true
      start_time = "03:00"
    }
    
    ip_configuration {
      ipv4_enabled    = true
      require_ssl     = true
    }
  }
}

resource "google_sql_database" "default_db" {
  name     = var.database_name
  instance = google_sql_database_instance.postgres_instance.name
}

resource "google_sql_user" "default_user" {
  name     = var.user_name
  instance = google_sql_database_instance.postgres_instance.name
  password = var.user_password
}
