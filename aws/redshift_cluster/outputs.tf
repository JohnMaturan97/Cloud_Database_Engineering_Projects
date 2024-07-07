output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.prod_vpc.id
}

output "internet_gateway_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.prod_igw.id
}

output "subnet_ids" {
  description = "IDs of the subnets"
  value       = [
    aws_subnet.prod_redshift_subnet_1.id,
    aws_subnet.prod_redshift_subnet_2.id
  ]
}

output "redshift_cluster_endpoint" {
  description = "The endpoint address of the Redshift cluster"
  value       = aws_redshift_cluster.prod_redshift_cluster.endpoint
}

output "redshift_cluster_vpc_security_group_ids" {
  description = "VPC security group IDs associated with the Redshift cluster"
  value       = aws_redshift_cluster.prod_redshift_cluster.vpc_security_group_ids
}
