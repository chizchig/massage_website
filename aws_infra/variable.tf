
variable "name" {
  type = string
}

variable "vpc_cidr_block" {
  type = string
}

variable "azs" {
  type = list(string)
}

# variable "public_subnets" {
#   type = map(object({
#     cidr = string
#     az   = string
#   }))
# }

# variable "private_subnets" {
#   type = map(object({
#     cidr = string
#     az   = string
#   }))
# }

# variable "database_subnets" {
#   type = map(object({
#     cidr = string
#     az   = string
#   }))
# }

variable "enable_nat_gateway" {
  type    = bool
  default = false
}

variable "enable_vpn_gateway" {
  type    = bool
  default = false
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "node_groups" {
  description = "Map of node groups with instance types, sizes, and scaling configurations."
  type = map(object({
    instance_type    = string
    desired_capacity = number
    min_size         = number
    max_size         = number
  }))
}

variable "cluster_name" {
  type    = string
  default = "star-eks-cluster"
}

variable "cluster_version" {
  type    = string
  default = "1.23"
}

variable "public_subnets" {
  type = map(object({
    cidr = string
    az   = string
  }))
}


# variable "roles" {
#   type = map(object({
#     name     = string
#     policies = list(string)
#   }))
#   default = {
#     eks_role = {
#       name     = "eks-role"
#       policies = ["arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"]
#     }
#     node_role = {
#       name     = "node-role"
#       policies = [
#         "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
#         "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
#         "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#       ]
#     }
#   }
# }

# output "public_subnets" {
#   value = {
#     for subnet in aws_subnet.public :
#     subnet.id => subnet.id
#   }
# }

variable "roles" {
  type = map(object({
    name        = string
    policy_arns = list(string)
  }))
}

variable "security_groups" {
  description = "A map of security group configurations"
  type = map(object({
    name          = string
    description   = string
    ingress_rules = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    egress_rules  = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks = list(string)
    }))
    tags          = map(string)
  }))
}

# variable "vpc_id" {
#   description = "The ID of the VPC where the security groups will be created"
#   type        = string
# }

variable "rds_instances" {
  description = "A map of RDS instance configurations"
  type = map(object({
    allocated_storage      = number
    storage_type           = string
    engine                 = string
    engine_version         = string
    instance_class         = string
    db_name                = string
    username               = string
    password               = string
    parameter_group_name   = string
    skip_final_snapshot    = bool
    publicly_accessible    = bool
    multi_az               = bool
    vpc_security_group_ids = list(string)
    tags                   = map(string)
  }))
}

variable "subnet_group" {
  description = "Configuration for the DB subnet group"
  type = object({
    name       = string
    subnet_ids = list(string)
    tags       = map(string)
  })
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs from the VPC module"
  type        = list(string)
  default     = []
}
