module "main" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.34"

  # Cluster Configuration
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # VPC Configuration
  vpc_id                   = var.vpc_id
  subnet_ids               = var.subnet_ids
  control_plane_subnet_ids = var.control_plane_subnet_ids
  # Cluster access
  cluster_endpoint_public_access       = var.enable_public_access
  cluster_endpoint_public_access_cidrs = var.public_access_cidrs
  cluster_endpoint_private_access      = var.enable_private_access

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true
  enable_irsa                              = true
  enable_efa_support                       = false // Only need for heavy compute workloads

  # Security Groups - Self-managed
  # Cluster Security Group
  create_cluster_security_group = true
  # cluster_security_group_id = var.cluster_security_group_id
  cluster_security_group_additional_rules = var.cluster_security_group_additional_rules

  # Node Security Group
  create_node_security_group = true
  # node_security_group_id = var.node_security_group_id
  node_security_group_additional_rules = var.node_security_group_additional_rules

  # EKS Addons
  bootstrap_self_managed_addons = null
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  eks_managed_node_groups = var.node_groups
  tags                    = var.tags
}