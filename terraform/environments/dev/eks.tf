locals {
  bastion_public_ip = length(module.ec2_instances["bastion"]) > 0 ? "${module.ec2_instances["bastion"].public_ip}/32" : "0.0.0.0/0"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.private_subnets

  // Node Groups
  node_groups = var.node_groups

  // Security Groups
  # cluster_security_group_id = module.networking.eks_cluster_security_group_id
  # node_security_group_id    = module.networking.eks_node_security_group_id

  cluster_security_group_additional_rules = {
    ingress_allow_bastion = {
      type                     = "ingress"
      description              = "Allow Bastion host to communicate with the EKS cluster"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.networking.bastion_security_group_id
    }
  }

  node_security_group_additional_rules = {
    ingress_allow_bastion = {
      type                     = "ingress"
      description              = "Allow Bastion host to communicate with the EKS cluster"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.networking.bastion_security_group_id
    },
    ingress_allow_mongodb = {
      type                     = "ingress"
      description              = "Allow MongoDB to communicate with the EKS cluster"
      protocol                 = "tcp"
      from_port                = 27017
      to_port                  = 27017
      source_security_group_id = module.networking.mongodb_security_group_id
    }
  }



  // Allow public access to the EKS cluster from the admin IP ranges and the Bastion host
  enable_private_access = true
  enable_public_access  = local.is_dev
  public_access_cidrs   = local.is_dev ? var.admin_ip_ranges : []

  tags = local.tags
}
