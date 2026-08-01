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
}