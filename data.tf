data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_vpc" "default" {
  default = true
}

data "default_vpc_route_table" {
  default_vpc_id = data.aws_vpc.default.main_route_table_id
}