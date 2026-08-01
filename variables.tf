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
    default = {}
}
