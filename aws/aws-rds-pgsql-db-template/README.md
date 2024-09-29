# RDS PostgreSQL Instance Setup

This Terraform configuration provisions an AWS VPC, networking resources, security group, and an Amazon RDS PostgreSQL instance using custom modules.

## Prerequisites

- Terraform v1.0.0 or higher
- AWS CLI configured with necessary permissions
- An existing AWS account with VPC, subnet, and security group management permissions

## Modules

This project uses the following Terraform modules:

1. **VPC Module**  
   Source: `JohnMaturan97/vpc-module/aws`  
   Version: `1.0.0`

2. **Networking Module**  
   Source: `JohnMaturan97/aredsft-networking/aws`  
   Version: `1.0.0`

3. **Security Module**  
   Source: `JohnMaturan97/aredsft-security/aws`  
   Version: `1.0.0`

## Resources

1. **VPC**  
   A new VPC is created with the CIDR block `10.0.0.0/16`. It is tagged as `ProdVPC`.

2. **Subnets**  
   Two subnets are created in `us-east-1a` and `us-east-1b` availability zones for Redshift.

3. **Security Group**  
   A security group is created with the following rules:
   - Ingress: Allow all traffic for testing.
   - Egress: Allow all outbound traffic.

4. **RDS PostgreSQL Instance**  
   A PostgreSQL instance is provisioned with:
   - Engine version: `14.12`
   - Instance class: `db.t4g.micro`
   - Allocated storage: `20 GB`
   - Publicly accessible: `True`
   - Performance insights enabled with KMS key.

## How to Use

1. Initialize Terraform:
    ```bash
    terraform init
    ```

2. Plan the changes:
    ```bash
    terraform plan
    ```

3. Apply the changes:
    ```bash
    terraform apply
    ```

## Variables

The following variables are used in the configuration:

- `database_name`: The name of the PostgreSQL database.
- `master_username`: The master username for the PostgreSQL instance.
- `master_password`: The master password for the PostgreSQL instance.

## Dependencies

- KMS key for performance insights is required.
- The RDS instance depends on the networking and security resources being provisioned first.

## Cleanup

To destroy the infrastructure, run:
```bash
terraform destroy
```

## License

This project is licensed under the MIT License.
