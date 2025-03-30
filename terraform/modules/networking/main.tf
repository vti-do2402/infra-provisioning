locals {
  is_prod = var.tags["Environment"] == "prod"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19"

  name = var.vpc_name
  cidr = var.vpc_cidr

  // Subnets configuration
  azs              = var.availability_zones
  private_subnets  = var.private_subnet_cidrs
  public_subnets   = var.public_subnet_cidrs
  intra_subnets    = var.intra_subnet_cidrs
  database_subnets = var.database_subnet_cidrs

  # Let EC2 instances control their own public IP assignment
  map_public_ip_on_launch = false
  create_igw              = true

  # Database Subnet configuration
  create_database_nat_gateway_route  = true
  create_database_subnet_group       = true
  create_database_subnet_route_table = true

  # NAT Gateway configuration
  enable_nat_gateway   = true
  single_nat_gateway   = !local.is_prod
  enable_dns_hostnames = true
  enable_dns_support   = true

  # VPC Flow Logs
  enable_flow_log                      = local.is_prod
  create_flow_log_cloudwatch_log_group = local.is_prod
  create_flow_log_cloudwatch_iam_role  = local.is_prod
  flow_log_max_aggregation_interval    = 60

  # Disable default resources
  manage_default_security_group = false
  manage_default_route_table    = false
  manage_default_network_acl    = true
  manage_default_vpc            = false


  # Subnet tags for EKS
  private_subnet_tags  = var.private_subnet_tags
  public_subnet_tags   = var.public_subnet_tags
  intra_subnet_tags    = var.intra_subnet_tags
  database_subnet_tags = var.database_subnet_tags
  tags                 = var.tags
}

# Security Groups
module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.prefix}-bastion-sg"
  description = "Security group for Bastion Host"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH from admin IPs"
      cidr_blocks = join(",", var.admin_ip_ranges)
    }
  ]

  egress_rules = ["all-all"]
  tags         = var.tags
}

module "mongodb_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.prefix}-mongodb-sg"
  description = "Security group for MongoDB instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      description              = "Bastion to MongoDB"
      protocol                 = "tcp"
      from_port                = 22
      to_port                  = 22
      source_security_group_id = module.bastion_sg.security_group_id
    },
    {
      description              = "Node groups to MongoDB"
      protocol                 = "tcp"
      from_port                = 27017
      to_port                  = 27017
      source_security_group_id = module.eks_node_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
  tags         = var.tags
}

################################################################################
# Cluster Security Group
# Defaults follow https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
################################################################################

module "eks_cluster_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.prefix}-eks-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = module.vpc.vpc_id

  # Ingress rules

  ingress_with_source_security_group_id = [
    {
      description              = "Node groups to cluster API"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.eks_node_sg.security_group_id
    },
    {
      description              = "Bastion to cluster API"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]

  tags = merge(var.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
    "aws:eks:cluster-name"                      = "${var.cluster_name}"
    Role                                        = "EKSCluster"
  })

}

################################################################################
# Node Security Group
# Defaults follow https://docs.aws.amazon.com/eks/latest/userguide/sec-group-reqs.html
# and https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/node_groups.tf
################################################################################

module "eks_node_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.prefix}-eks-node-sg"
  description = "Security group for EKS node groups"
  vpc_id      = module.vpc.vpc_id

  ingress_with_self = [
    {
      description = "Node to node CoreDNS"
      protocol    = "tcp"
      from_port   = 53
      to_port     = 53
    },
    {
      description = "Node to node CoreDNS UDP"
      protocol    = "udp"
      from_port   = 53
      to_port     = 53
    },
    {
      description = "Node to node ingress on ephemeral ports"
      protocol    = "tcp"
      from_port   = 1025
      to_port     = 65535
    }
  ]

  ingress_with_source_security_group_id = [
    {
      description              = "Bastion to node kubelets"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.bastion_sg.security_group_id
    },
    {
      description              = "Cluster API to node groups"
      protocol                 = "tcp"
      from_port                = 443
      to_port                  = 443
      source_security_group_id = module.eks_cluster_sg.security_group_id
    },
    {
      description              = "Cluster API to node kubelets"
      protocol                 = "tcp"
      from_port                = 10250
      to_port                  = 10250
      source_security_group_id = module.eks_cluster_sg.security_group_id
    },
    {
      description              = "MongoDB to Node Groups"
      protocol                 = "tcp"
      from_port                = 27017
      to_port                  = 27017
      source_security_group_id = module.mongodb_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
  tags = merge(var.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned",
    "aws:eks:cluster-name"                      = "${var.cluster_name}",
    Role                                        = "EKSNodeGroup"
  })
}

