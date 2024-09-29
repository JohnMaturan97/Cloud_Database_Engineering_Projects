resource "aws_db_parameter_group" "pgsql_db_param_group" {
  name        = "aapsql-apm1234567-prdcl01-param-group"
  family      = "postgres14"
  description = "Custom parameter group for PostgreSQL"

  parameter {
    name  = "log_connections"
    value = "1"
  }

  parameter {
    name         = "shared_preload_libraries"
    value        = "pg_stat_statements,pgaudit"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "1200000"
  }

  parameter {
    name  = "log_disconnections"
    value = "1"
  }

  parameter {
    name  = "log_statement"
    value = "mod"
  }

  parameter {
    name  = "pgaudit.role"
    value = "rds_pgaudit"
  }

  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "password_encryption"
    value        = "SCRAM-SHA-256"
    apply_method = "pending-reboot"
  }

  parameter {
    name  = "log_duration"
    value = "1"
  }

  parameter {
    name  = "log_error_verbosity"
    value = "verbose"
  }

  parameter {
    name  = "pgaudit.log"
    value = "All"
  }
}
