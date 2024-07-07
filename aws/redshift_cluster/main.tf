resource "aws_vpc" "prod_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = "ProdVPC"
  }
}

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id
  tags = {
    Name = "ProdInternetGateway"
  }
}

resource "aws_route_table" "prod_route_table" {
  vpc_id = aws_vpc.prod_vpc.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.prod_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod_igw.id
}

resource "aws_subnet" "prod_redshift_subnet_1" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name = "ProdRedshiftSubnet1"
  }
}

resource "aws_subnet" "prod_redshift_subnet_2" {
  vpc_id            = aws_vpc.prod_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
    Name = "ProdRedshiftSubnet2"
  }
}

resource "aws_route_table_association" "prod_association_1" {
  subnet_id      = aws_subnet.prod_redshift_subnet_1.id
  route_table_id = aws_route_table.prod_route_table.id
}

resource "aws_route_table_association" "prod_association_2" {
  subnet_id      = aws_subnet.prod_redshift_subnet_2.id
  route_table_id = aws_route_table.prod_route_table.id
}

resource "aws_security_group" "prod_redshift_sg" {
  name        = "ProdRedshiftAllTraffic"
  description = "Security group for Redshift in production that allows all traffic"
  vpc_id      = aws_vpc.prod_vpc.id

  ingress {
    description = "All traffic for testing"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_redshift_cluster" "prod_redshift_cluster" {
  cluster_identifier           = "prod-redshift-cluster01"
  database_name                = var.redshift_database_name
  master_username              = var.redshift_master_username
  master_password              = var.redshift_master_password
  node_type                    = "dc2.large"
  number_of_nodes              = 2
  publicly_accessible          = true
  cluster_parameter_group_name = aws_redshift_parameter_group.prod_parameter_group.name
  cluster_subnet_group_name    = aws_redshift_subnet_group.prod_subnet_group.name
  vpc_security_group_ids       = [aws_security_group.prod_redshift_sg.id]
  skip_final_snapshot          = true

  tags = {
    Environment = "Production"
    Team        = "Data Analytics"
    Project     = "Andromeda Insights"
    ManagedBy   = "DBOPs Team"
  }
}

resource "aws_redshift_subnet_group" "prod_subnet_group" {
  name = "prod-redshift-subnet-group"
  subnet_ids = [
    aws_subnet.prod_redshift_subnet_1.id,
    aws_subnet.prod_redshift_subnet_2.id
  ]
  tags = {
    Name = "ProdRedshiftSubnetGroup"
  }
}
