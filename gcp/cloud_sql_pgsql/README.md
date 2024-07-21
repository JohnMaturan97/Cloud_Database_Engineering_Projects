# GCP CloudSQL Terraform Project

## Overview

This Terraform project sets up a PostgreSQL instance on Google Cloud Platform (GCP) using CloudSQL. It includes resources for enabling necessary APIs, creating the SQL instance, database, and user.

## Files

### provider.tf
This file configures the Terraform provider for GCP.

```hcl
terraform {
  cloud {
    organization = "Andromeda101"

    workspaces {
      name = "gcp-andromeda-slvr"
    }
  }
}

provider "google" {
  credentials = file("gcp-credentials.json")
  project     = var.project_id
  region      = var.region
}
```

### variables.tf
This file defines the variables used throughout the Terraform configuration.

```hcl
variable "project_id" {
  description = "Google Cloud project ID"
  type        = string
}

variable "region" {
  description = "Region for Google Cloud resources"
  default     = "us-central1"
}

variable "instance_name" {
  description = "Name of the SQL instance"
  default     = "pgsql-gcp-dev01"
}

variable "database_name" {
  description = "Name of the database within the SQL instance"
  default     = "pgsql-dev"
}

variable "user_name" {
  description = "Name of the database user"
  default     = "pgsql_user"
}

variable "user_password" {
  description = "Password for the database user"
  type        = string
  sensitive   = true
}
```

### gcp_pgsql.tf
This file contains the main Terraform resources for setting up the CloudSQL instance, database, and user.

```hcl
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
```

## Deployment

To deploy the CloudSQL instance using this Terraform project:

1. **Initialize Terraform:**
   ```sh
   terraform init
   ```

2. **Plan the Deployment:**
   ```sh
   terraform plan
   ```

3. **Apply the Configuration:**
   ```sh
   terraform apply
   ```

Make sure to provide the necessary variables, either through a `terraform.tfvars` file or as command-line arguments.

## Credentials

Place your GCP service account credentials in a file named `gcp-credentials.json` in the project root. The credentials should have permissions to manage CloudSQL instances.

```json
{
  "type": "service_account",
  "project_id": "your-project-id",
  "private_key_id": "your-private-key-id",
  "private_key": "-----BEGIN PRIVATE KEY-----
...
-----END PRIVATE KEY-----
",
  "client_email": "your-client-email",
  "client_id": "your-client-id",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/your-client-email"
}
```


