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
}