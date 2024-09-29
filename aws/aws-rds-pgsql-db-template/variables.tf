variable "aws_region" {
  description = "AWS Region for the Redshift cluster"
  type        = string
}

variable "Access_Key_ID" {
  description = "AWS Access Key ID"
  type        = string
}

variable "Secret_Access_Key" {
  description = "AWS Secret Access Key"
  type        = string
}

variable "database_name" {
  description = "Master username for Redshift cluster"
  type        = string
}

variable "master_username" {
  description = "Master username for Redshift cluster"
  type        = string
}

variable "master_password" {
  description = "Master password for Redshift cluster"
  type        = string
  sensitive   = true
}