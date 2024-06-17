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