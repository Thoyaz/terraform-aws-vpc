variable "project" {
    type = string
}

variable "environment" {
    type = string
}

variable "vpc_cidr" {
    type = string
    default = "10.0.0.0/16"
}

variable "instance_tenancy" {
    type = string
    default = "default"
}

variable "vpc_tags" {
    type = map(string)
    default = {}
}

variable "igw_tags" {
    type = map(string)
    default = {}
}

variable "public_subnet_cidr" {
    type = list(string)
    default = []
}

variable "public_subnet_tags" {
    type = map(string)
    default = {}
}

variable "private_subnet_cidr" {
    type = list(string)
    default = []
}

variable "private_subnet_tags" {
    type = map(string)
    default = {}
}

variable "database_subnet_cidr" {
    type = list(string)
    default = []
}

variable "database_subnet_tags" {
    type = map(string)
    default = {}
}

# Route table tags
variable "public_route_table_tags" {
    type = map(string)
    default = {}
}

variable "private_route_table_tags" {
    type = map(string)
    default = {}
}

variable "database_route_table_tags" {
    type = map(string)
    default = {}
}


variable "nat_eip_tags" {
    type = map(string)
    default = {}
}

variable "nat_gateway_tags" {
    type = map(string)
    default = {}
}
