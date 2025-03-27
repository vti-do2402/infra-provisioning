# Get VPC information
data "aws_vpc" "selected" {
  id = var.vpc_id
}

# Bastion host security group
module "bastion" {
  source = "./groups/bastion"

  name_prefix = var.cluster_name
  vpc_id      = var.vpc_id
  admin_ip    = var.admin_ip
  tags        = var.tags
}

# MongoDB security group
module "mongodb" {
  source = "./groups/mongodb"

  name_prefix              = var.cluster_name
  vpc_id                   = var.vpc_id
  vpc_cidr                 = data.aws_vpc.selected.cidr_block
  additional_allowed_cidrs = var.mongodb_allowed_cidrs
  bastion_security_group_id = module.bastion.security_group_id
  mongodb_port             = var.mongodb_port
  tags                     = var.tags
}

# EKS node group security group
module "eks_node_group" {
  source = "./groups/eks"

  name_prefix               = var.cluster_name
  vpc_id                    = var.vpc_id
  cluster_security_group_id = var.cluster_security_group_id
  bastion_security_group_id = module.bastion.security_group_id
  tags                      = var.tags
}