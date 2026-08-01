# Create VPC
resource "aws_vpc" "main" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.instance_tenancy

  tags = local.all_vpc_tags
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = local.all_igw_tags
}

# Create public subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(local.all_public_subnet_tags,{
    Name = "${var.project}-${var.environment}-public-subnet-${local.availability_zones[count.index]}"
  } )
}

# Create private subnets
resource "aws_subnet" "private" {
  count = length(var.private_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.private_subnet_cidr[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = merge(local.all_private_subnet_tags,{
    Name = "${var.project}-${var.environment}-private-subnet-${local.availability_zones[count.index]}"
  } )
}

# Create database subnets
resource "aws_subnet" "database" {
  count = length(var.database_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.database_subnet_cidr[count.index]
  availability_zone = local.availability_zones[count.index]

  tags = merge(local.all_database_subnet_tags,{
    Name = "${var.project}-${var.environment}-database-subnet-${local.availability_zones[count.index]}"
  } )
}

# Route table for public subnets
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  tags = local.all_public_route_table_tags
}

# Route table for private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = local.all_private_route_table_tags
}

# Route table for database subnets
resource "aws_route_table" "database" {
  vpc_id = aws_vpc.main.id

  tags = local.all_database_route_table_tags
}

# Routes for public subnets
resource "aws_route" "public" {
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.gw.id
}

# elastic IP
resource "aws_eip" "eip" {
  domain   = "vpc"
  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-eip"
  })
}


# NAT Gateway
resource "aws_nat_gateway" "nat_gateway" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.public[0].id   # we are creating NAT gateway in the first public subnet (us-east-1a)

  tags = merge(local.common_tags, {
    Name = "${var.project}-${var.environment}-nat-gateway"
  })

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_eip.eip, aws_internet_gateway.gw]
}

# Routes for private subnets
resource "aws_route" "private" {
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gateway.id
}

# Routes for database subnets
resource "aws_route" "database" {
  route_table_id            = aws_route_table.database.id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_nat_gateway.nat_gateway.id
}


# Route table associations for public subnets
resource "aws_route_table_association" "public" {
  count = length(var.public_subnet_cidr)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Route table associations for private subnets
resource "aws_route_table_association" "private" {
  count = length(var.private_subnet_cidr)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# Route table associations for database subnets
resource "aws_route_table_association" "database" {
  count = length(var.database_subnet_cidr)
  subnet_id      = aws_subnet.database[count.index].id
  route_table_id = aws_route_table.database.id
}