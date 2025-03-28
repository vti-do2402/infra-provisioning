module "main" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.34"

  # Cluster Configuration
  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  # VPC Configuration
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Cluster access
  cluster_endpoint_public_access = var.enable_public_access
  cluster_endpoint_public_access_cidrs = var.public_access_cidrs

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  # Security Groups - let EKS create the cluster security group and just add additional ones if needed
  cluster_additional_security_group_ids = var.additional_security_group_ids

  # Disable default addons - we'll manage these separately if needed
  # bootstrap_self_managed_addons = false
  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }  

  eks_managed_node_groups = var.node_groups
  tags = var.tags
}

# Get current caller identity
data "aws_caller_identity" "current" {}

# 