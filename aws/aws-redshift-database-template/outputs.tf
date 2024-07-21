
output "vpc_id" {
  value = module.vpc-module.vpc_id
}

output "subnet_ids" {
  value = module.aredsft-networking.subnet_ids
}

output "security_group_id" {
  value = module.aredsft-security.security_group_id
}

output "redshift_cluster_id" {
  value = module.aredsft-cluster.redshift_cluster_id
}

output "redshift_cluster_endpoint" {
  value = module.aredsft-cluster.redshift_cluster_endpoint
}
