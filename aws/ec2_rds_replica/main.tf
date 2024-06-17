##################################### VPC code #####################################
resource "aws_vpc" "amc-vpc" {
  tags                 = merge(var.tags, {})
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
}
######################################## END #######################################


##################################### EC2 Code #####################################
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

resource "aws_instance" "server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_a.id
  associate_public_ip_address = true
  security_groups             = [aws_security_group.ec2_sg.id]
  tags = {
    Name = "server"
  }
}

resource "aws_security_group" "ec2_sg" {
  name        = "ec2_sg"
  description = "Security group for EC2 instances"
  vpc_id      = aws_vpc.amc-vpc.id

  tags = {
    Name = "EC2 Security Group"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2_sg_ig1" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "tcp"
  from_port         = 0
  to_port           = 65535
}

resource "aws_vpc_security_group_egress_rule" "ec2_sg_eg1" {
  security_group_id = aws_security_group.ec2_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "tcp"
  to_port     = 65535
}

######################################## END #######################################


##################################### RDS Code #####################################
resource "aws_db_instance" "primary-db01" {
  username                = "amonkincloud"
  identifier              = "aapsql-apm1234567-prdcl01"
  skip_final_snapshot     = true
  publicly_accessible     = false
  password                = var.master_user_db_password
  parameter_group_name    = aws_db_parameter_group.log_db_parameter.name
  instance_class          = var.instance_class
  engine_version          = "16.1"
  db_name                 = "dev"
  engine                  = "postgres"
  db_subnet_group_name    = aws_db_subnet_group.default.name
  backup_retention_period = 1
  allocated_storage       = 50
  multi_az                = true

  tags = {
    environment = "Dev"
  }

  vpc_security_group_ids = [
    aws_security_group.sg.id
  ]
}

resource "aws_db_subnet_group" "default" {
  name        = "default_subnet_group"
  description = "The default subnet group for all DBs in this architecture"

  subnet_ids = [
    aws_subnet.private_a.id,
    aws_subnet.private_b.id,
  ]

  tags = {
    env = "Dev"
  }
}

resource "aws_db_parameter_group" "log_db_parameter" {
  name   = "logs"
  family = "postgres16"

  parameter {
    value = "1"
    name  = "log_connections"
  }

  tags = {
    env = "Dev"
  }
}

resource "aws_security_group" "sg" {
  name        = "db_sg"
  description = "Default sg for the database"
  vpc_id      = aws_vpc.amc-vpc.id

  # Allow PostgreSQL access from anywhere on port 5432
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#     description = "Allow PostgreSQL access from anywhere"
#   }

  # Additional rule for EC2 instances within a specific SG
  ingress {
    from_port                    = 5432
    to_port                      = 5432
    protocol                     = "tcp"
    security_groups              = [aws_security_group.ec2_sg.id]
    description                  = "Allow PostgreSQL access from EC2 instances"
  }

  # Specific ingress rule for your local IP range
#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["192.168.0.0/16"]
#     description = "Allow PostgreSQL access from local IP range"
#   }

  tags = {
    Name = "db_sg"
  }
}

resource "aws_db_instance" "db_replica01" {
  skip_final_snapshot     = true
  replicate_source_db     = aws_db_instance.primary-db01.identifier
  publicly_accessible     = false
  parameter_group_name    = aws_db_parameter_group.log_db_parameter.name
  instance_class          = var.instance_class
  identifier              = "aapsql-apm1234567-90prdcl01"
  backup_retention_period = 7
  apply_immediately       = true

  tags = {
    replica = "true"
    env     = "Dev"
  }

  vpc_security_group_ids = [
    aws_security_group.sg.id,
  ]
}
######################################## END #######################################