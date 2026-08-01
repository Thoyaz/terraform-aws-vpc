resource "aws_vpc_peering_connection" "default" {
  count = var.is_peering_required ? 1 : 0
  #peer_owner_id = var.peer_owner_id
  peer_vpc_id   = data.aws_vpc.default.id #vpc-00d9de542572a13ec
  vpc_id        = var.requester_vpc_id #vpc-0fd2c34702a25e94e
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = local.all_vpc_peering_connection_tags
}

# Routes for public subnets to the peered VPC
resource "aws_route" "public_peering" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = data.aws_vpc.default.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}

# Peered VPC route to the public subnets
resource "aws_route" "default_vpc_to_public_vpc" {
  count = var.is_peering_required ? 1 : 0
  route_table_id            = data.aws_vpc.default.main_route_table_id
  destination_cidr_block    = var.vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.default.id
}
