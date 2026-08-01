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
resource "aws_subnet" "main" {
  count = length(var.public_subnet_cidr)
  vpc_id     = aws_vpc.main.id
  cidr_block = var.public_subnet_cidr[count.index]
  availability_zone = local.availability_zones[count.index]


  tags = merge(local.all_public_subnet_tags,{
    Name = "${var.project}-${var.environment}-public-subnet-${local.availability_zones[count.index]}"
  } )
}