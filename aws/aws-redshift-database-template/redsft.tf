locals {
  serial_number = "97"
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

module "aredsft-cluster" {
  source  = "JohnMaturan97/aredsft-cluster/aws"
  version = "1.0.0"

  cluster_identifier = "aredsft-apm04231978-prdcl${local.serial_number}"
  database_name      = var.database_name
  master_username    = var.master_username
  master_password    = var.master_password
  node_type          = "dc2.large"
  number_of_nodes    = 2
  subnet_group_name  = module.aredsft-networking.subnet_group_name
  security_group_ids = [module.aredsft-security.security_group_id]
  cluster_tags = {
    Environment = "Production"
    Team        = "Data Analytics"
    Project     = "Andromeda Insights"
    ManagedBy   = "DBOPs Team"
  }

  depends_on = [module.aredsft-networking]
}
