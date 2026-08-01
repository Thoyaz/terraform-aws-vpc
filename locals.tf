locals {
    common_tags = {
        project = var.project
        environment = var.environment
        terraform = "true"
    }
    all_vpc_tags = merge(local.common_tags,
        var.vpc_tags, {
            Name = "${var.project}-${var.environment}-vpc"
        }
    )

    all_igw_tags = merge(local.common_tags,
        var.igw_tags, {
            Name = "${var.project}-${var.environment}-igw"
        }
    )

    availability_zones = slice(data.aws_availability_zones.available.names, 0, 2)

    all_public_subnet_tags = merge(local.common_tags, var.public_subnet_tags)
    all_private_subnet_tags = merge(local.common_tags, var.private_subnet_tags)
    all_database_subnet_tags = merge(local.common_tags, var.database_subnet_tags)

    # Route table tags
    all_public_route_table_tags = merge(local.common_tags, var.public_route_table_tags, {
        Name = "${var.project}-${var.environment}-public-rt"
    })
    all_private_route_table_tags = merge(local.common_tags, var.private_route_table_tags, {
        Name = "${var.project}-${var.environment}-private-rt"
    })
    all_database_route_table_tags = merge(local.common_tags, var.database_route_table_tags, {
        Name = "${var.project}-${var.environment}-database-rt"
    })
}