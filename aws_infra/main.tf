data "aws_availability_zones" "available" {
  state = "available"
}


module "vpc" {
  source = "./modules/vpc"

  name             = var.name
  vpc_cidr_block   = var.vpc_cidr_block
  azs              = local.az_names
  public_subnets   = local.public_subnets
  private_subnets  = local.private_subnets
  database_subnets = local.database_subnets

  enable_nat_gateway = false
  enable_vpn_gateway = true

  tags = {
    Name = "${var.name}_vpc"
  }
}

module "eks" {
  source = "./modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # VPC Configuration
  # vpc_id          = module.vpc.vpc_id
  public_subnets  = module.vpc.public_subnets
  # private_subnets = module.vpc.private_subnets

  # Node groups configuration
  node_groups     = var.node_groups

  # IAM roles configuration
  roles           = var.roles

  # Tags
  # tags = {
  #   Environment = var.environment
  #   Project     = var.project_name
  # }
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id          = module.vpc.vpc_id
  security_groups = var.security_groups
}

module "rds" {
  source = "./modules/rds"

  rds_instances = {
    for k, v in var.rds_instances : k => merge(v, {
      vpc_security_group_ids = values(module.security_group.security_group_ids)  # Use all security group IDs

    })
  }

  private_subnet_ids = values(module.vpc.private_subnet_ids)  # Convert map to list

  subnet_group = {
    name       = "${var.name}-db-subnet-group"
    subnet_ids = coalesce(var.subnet_group.subnet_ids, values(module.vpc.database_subnet_ids))
    tags       = {
      Name = "${var.name}-db-subnet-group"
    }
  }
}