locals {
  serial_number = "02"
}


module "vpc-module" {
  source  = "JohnMaturan97/vpc-module/aws"
  version = "1.0.0"

  cidr_block = "10.0.0.0/16"
  vpc_tags = {
    Name = "ProdVPC"
  }
}

module "aredsft-networking" {
  source  = "JohnMaturan97/aredsft-networking/aws"
  version = "1.0.0"

  vpc_id = module.vpc-module.vpc_id
  subnet_definitions = [
    {
      cidr_block        = "10.0.1.0/24"
      availability_zone = "us-east-1a"
      name              = "ProdRedshiftSubnet1"
    },
    {
      cidr_block        = "10.0.2.0/24"
      availability_zone = "us-east-1b"
      name              = "ProdRedshiftSubnet2"
    }
  ]
}

module "aredsft-security" {
  source  = "JohnMaturan97/aredsft-security/aws"
  version = "1.0.0"

  vpc_id = module.vpc-module.vpc_id

  ingress_rules = [
    {
      description = "All traffic for testing"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]

  egress_rules = [
    {
      description = "All outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}

resource "aws_db_subnet_group" "rds_subnet_group" {
  name        = "prod-postgres-subnet-group"
  description = "Subnet group for RDS PostgreSQL instance"
  subnet_ids  = module.aredsft-networking.subnet_ids

  tags = {
    Name = "prod-postgres-subnet-group"
  }
}

resource "aws_db_instance" "postgres_rds_instance" {
  identifier              = "aapsql-apm1234567-prdcl${local.serial_number}"
  engine                  = "postgres"
  engine_version          = "14.12"
  instance_class          = "db.t4g.micro"
  allocated_storage       = 20
  storage_type            = "gp2"
  name                    = var.database_name
  username                = var.master_username
  password                = var.master_password
  parameter_group_name    = aws_db_parameter_group.aapsql_apm1234567_prdcl01_param_group.name
  db_subnet_group_name    = aws_db_subnet_group.rds_subnet_group.name
  vpc_security_group_ids  = [module.aredsft-security.security_group_id]
  skip_final_snapshot     = true
  deletion_protection     = false
  publicly_accessible     = true
  backup_retention_period = 1

  performance_insights_enabled    = true
  performance_insights_kms_key_id = aws_kms_key.pi_kms_key.arn

  tags = {
    Name = "aapsql-apm1234567-prdcl01"
  }

  depends_on = [
    aws_kms_key.pi_kms_key,
    module.aredsft-networking,
    module.aredsft-security,
    aws_db_subnet_group.rds_subnet_group
  ]
}
