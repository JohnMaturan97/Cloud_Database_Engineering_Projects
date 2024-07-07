variable "Access_Key_ID" {
  type = string
}

variable "Secret_Access_Key" {
  type = string
}

variable "redshift_database_name" {
  description = "The database name for the Redshift cluster"
  type        = string
}

variable "redshift_master_username" {
  description = "The master username for the Redshift cluster"
  type        = string
}

variable "redshift_master_password" {
  description = "The master password for the Redshift cluster"
  type        = string
  sensitive   = true
}