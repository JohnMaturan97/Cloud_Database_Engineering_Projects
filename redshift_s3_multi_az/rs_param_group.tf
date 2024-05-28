resource "aws_redshift_parameter_group" "prod_parameter_group" {
  name   = "prod-redshift-parameter-group"
  family = "redshift-1.0"

  parameter {
    name  = "enable_user_activity_logging"
    value = "true"
  }

  parameter {
    name  = "max_cursor_result_set_size"
    value = "2000"
  }

  parameter {
    name  = "query_group"
    value = "default"
  }

  parameter {
    name  = "require_ssl"
    value = "false"
  }

  tags = {
    Environment = "production"
  }
}
