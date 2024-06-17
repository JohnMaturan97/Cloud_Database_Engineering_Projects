################################## Public Subnet Code ###############################
resource "aws_internet_gateway" "amc-vpc-igw" {
  vpc_id = aws_vpc.amc-vpc.id
  tags   = merge(var.tags, {})
}

resource "aws_subnet" "public_b" {
  vpc_id            = aws_vpc.amc-vpc.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.b
  availability_zone = "us-east-1b"
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.amc-vpc.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.a
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.amc-vpc.id
  tags              = merge(var.tags, {})
  cidr_block        = var.subnets.c
  availability_zone = "us-east-1c"
}

resource "aws_eip" "eip_b" {
  tags = merge(var.tags, {})
}

resource "aws_eip" "eip_a" {
  tags = merge(var.tags, {})
}

resource "aws_eip" "eip_c" {
  tags = merge(var.tags, {})
}

resource "aws_nat_gateway" "nat-gw-1a-public" {
  allocation_id = aws_eip.eip_a.id
  subnet_id     = aws_subnet.public_a.id
  tags          = merge(var.tags, {})
  depends_on    = [aws_eip.eip_a]
}

resource "aws_nat_gateway" "nat-gw-1b-public" {
  allocation_id = aws_eip.eip_b.id
  subnet_id     = aws_subnet.public_b.id
  tags          = merge(var.tags, {})
  depends_on    = [aws_eip.eip_b]
}

resource "aws_nat_gateway" "nat-gw-1c-public" {
  allocation_id = aws_eip.eip_c.id
  subnet_id     = aws_subnet.public_c.id
  tags          = merge(var.tags, {})
  depends_on    = [aws_eip.eip_c]
}

resource "aws_route_table" "rt_public_a" {
  vpc_id = aws_vpc.amc-vpc.id
}

resource "aws_route_table_association" "rt_assoc_public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.rt_public_a.id
}

resource "aws_route" "route_a" {
  route_table_id         = aws_route_table.rt_public_a.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.amc-vpc-igw.id
}

resource "aws_route_table" "rt_public_b" {
  vpc_id = aws_vpc.amc-vpc.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table_association" "rt_assoc_public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.rt_public_b.id
}

resource "aws_route" "route_b" {
  route_table_id         = aws_route_table.rt_public_b.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.amc-vpc-igw.id
}

resource "aws_route_table" "rt_public_c" {
  vpc_id = aws_vpc.amc-vpc.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table_association" "rt_assoc_public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.rt_public_c.id
}

resource "aws_route" "route_c" {
  route_table_id         = aws_route_table.rt_public_c.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.amc-vpc-igw.id
}
######################################## END #######################################

################################## Private Code ####################################
resource "aws_route_table" "rt_private_a" {
  vpc_id = aws_vpc.amc-vpc.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table_association" "rt_assoc_private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.rt_private_a.id
}

resource "aws_route" "route_pa" {
  route_table_id         = aws_route_table.rt_private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-1a-public.id
}

resource "aws_route_table" "rt_private_b" {
  vpc_id = aws_vpc.amc-vpc.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table_association" "rt_assoc_private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.rt_private_b.id
}

resource "aws_route" "route_pb" {
  route_table_id         = aws_route_table.rt_private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-1b-public.id
}

resource "aws_route_table" "rt_private_c" {
  vpc_id = aws_vpc.amc-vpc.id
  tags   = merge(var.tags, {})
}

resource "aws_route_table_association" "rt_assoc_private_c" {
  subnet_id      = aws_subnet.private_c.id
  route_table_id = aws_route_table.rt_private_c.id
}

resource "aws_route" "route_pc" {
  route_table_id         = aws_route_table.rt_private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-gw-1c-public.id
}

resource "aws_subnet" "private_a" {
  vpc_id                  = aws_vpc.amc-vpc.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.a
  availability_zone       = "us-east-1a"
}

resource "aws_subnet" "private_b" {
  vpc_id                  = aws_vpc.amc-vpc.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.b
  availability_zone       = "us-east-1b"
}

resource "aws_subnet" "private_c" {
  vpc_id                  = aws_vpc.amc-vpc.id
  tags                    = merge(var.tags, {})
  map_public_ip_on_launch = false
  cidr_block              = var.private_subnets.c
  availability_zone       = "us-east-1c"
}
######################################## END #######################################