output "vpc_id" {
  value       = module.vpc-module.vpc_id
  description = "The ID of the VPC in which the RDS instance is deployed."
}

output "subnet_ids" {
  value       = module.aredsft-networking.subnet_ids
  description = "The subnet IDs assigned to the RDS instance."
}

output "security_group_id" {
  value       = module.aredsft-security.security_group_id
  description = "The security group ID attached to the RDS instance."
}

output "rds_instance_id" {
  value       = aws_db_instance.postgres_rds_instance.identifier
  description = "The identifier of the RDS instance."
}

output "rds_instance_endpoint" {
  value       = aws_db_instance.postgres_rds_instance.endpoint
  description = "The endpoint of the RDS instance."
}
