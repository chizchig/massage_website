output "public_subnets" {
  value = module.vpc.public_subnet_ids
}

# output "database_subnet_ids" {
#   value = module.vpc.database_subnets
# }

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "all_security_group_ids" {
  value = module.security_group.security_group_ids
}

output "all_security_group_arns" {
  value = module.security_group.security_group_arns
}

# You can access the outputs like this:
output "rds_endpoints" {
  value = module.rds.rds_endpoints
}

output "rds_instance_ids" {
  value = module.rds.rds_instance_ids
}

output "rds_instance_arns" {
  value = module.rds.rds_instance_arns
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "debug_security_group_ids" {
  value = module.security_group.security_group_ids
}