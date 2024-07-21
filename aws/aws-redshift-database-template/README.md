# AWS Redshift Terraform Module

## Introduction
This Terraform module is designed to deploy a production-ready AWS Redshift environment. It includes modules for VPC creation, networking, security, and the Redshift cluster itself, ensuring a fully operational data warehousing solution.

## Module Overview
- **VPC Module**: Sets up the VPC required for the Redshift cluster.
- **Networking Module**: Configures subnet and networking settings appropriate for Redshift.
- **Security Module**: Manages security groups for Redshift, allowing and restricting access as needed.
- **Redshift Cluster Module**: Deploys and configures the Redshift cluster.

## Prerequisites
- Terraform v0.12+
- AWS account with configured access and secret keys
- Appropriate IAM permissions for creating VPC, networking resources, and Redshift clusters

## Requirements
- **Provider**: AWS (Amazon Web Services)
- **Terraform Version**: >= 0.12.0
- **Provider Version**: AWS ~> 3.0

## Providers
- AWS: Used for managing all resources within Amazon Web Services.

## Configuration
The following variables need to be configured:
- `aws_region`: AWS Region for the Redshift cluster
- `Access_Key_ID`: AWS Access Key ID
- `Secret_Access_Key`: AWS Secret Access Key
- `database_name`: Database name for the Redshift cluster
- `master_username`: Master username for Redshift access
- `master_password`: Master password for Redshift access (sensitive)

## Usage
To use this module, include it in your Terraform configurations like this:

```hcl
module "aws_redshift" {
  source = "github.com/yourusername/aws-redshift-module"
  aws_region = "us-west-2"
  Access_Key_ID = "your_access_key"
  Secret_Access_Key = "your_secret_key"
  database_name = "your_database_name"
  master_username = "admin"
  master_password = "your_secure_password"
}
```

## Outputs
- `vpc_id`: The VPC ID created for the Redshift cluster
- `subnet_ids`: The IDs of the subnets created within the VPC
- `security_group_id`: The ID of the security group created for the Redshift cluster
- `redshift_cluster_id`: The identifier of the created Redshift cluster
- `redshift_cluster_endpoint`: The endpoint of the Redshift cluster
