locals {
  cluster_name      = "${var.cluster_name}-${local.tags["Environment"]}"
  bastion_public_ip = length(module.ec2_instances["bastion"]) > 0 ? "${module.ec2_instances["bastion"].public_ip}/32" : "0.0.0.0/0"
}

module "eks" {
  source = "../../modules/eks"

  cluster_name    = local.cluster_name
  cluster_version = var.cluster_version
  vpc_id          = module.networking.vpc_id
  subnet_ids      = module.networking.private_subnets

  # Add the EKS node security group as an additional security group
  additional_security_group_ids = [module.networking.eks_node_security_group_id]

  node_groups = var.node_groups

  // Allow public access to the EKS cluster from the admin IP ranges and the Bastion host
  enable_public_access = true
  public_access_cidrs = concat(
    var.admin_ip_ranges,
    [local.bastion_public_ip]
  )

  tags = local.tags
}
