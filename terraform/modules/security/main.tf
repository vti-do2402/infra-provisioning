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

  name_prefix               = var.cluster_name
  vpc_id                    = var.vpc_id
  allowed_cidr_blocks       = [data.aws_vpc.selected.cidr_block] # Allow access from within VPC
  bastion_security_group_id = module.bastion.security_group_id
  tags                      = var.tags
}

# EKS node group security group
module "eks_nodes" {
  source = "./groups/eks"

  name_prefix               = var.cluster_name
  vpc_id                    = var.vpc_id
  cluster_security_group_id = var.cluster_security_group_id
  bastion_security_group_id = module.bastion.security_group_id
  tags                      = var.tags
}