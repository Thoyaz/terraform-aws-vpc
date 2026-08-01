output "availability_zones" {
  value = data.aws_availability_zones.available
}

output "vpc_default" {
  value = data.aws_vpc.default.id
}