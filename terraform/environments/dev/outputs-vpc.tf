output "IDs" {
  description = "IDs"
  value = {
    vpc_id           = module.networking.vpc_id
    public_subnets   = module.networking.public_subnets
    private_subnets  = module.networking.private_subnets
    intra_subnets    = module.networking.intra_subnets
    database_subnets = module.networking.database_subnets
  }
}

output "CIDRs" {
  description = "CIDRs"
  value = {
    vpc_cidr         = var.vpc_cidr
    public_subnets   = module.networking.public_subnet_cidrs
    private_subnets  = module.networking.private_subnet_cidrs
    intra_subnets    = module.networking.intra_subnet_cidrs
    database_subnets = module.networking.database_subnet_cidrs
  }
}

output "security_groups" {
  description = "Security groups details"
  value = {
    bastion     = module.networking.bastion_security_group_id
    mongodb     = module.networking.mongodb_security_group_id
    eks_node    = module.networking.eks_node_security_group_id
    eks_cluster = module.networking.eks_cluster_security_group_id
  }
}