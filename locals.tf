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

    all_public_subnet_tags = merge(local.common_tags, {
        Name = "${var.project}-${var.environment}-public-subnet-${local.availability_zones}"
    })
}