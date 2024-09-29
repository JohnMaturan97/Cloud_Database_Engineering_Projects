resource "aws_db_parameter_group" "aapsql_apm1234567_prdcl01_param_group" {
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
}
