locals {
  is_prod = var.tags["Environment"] == "prod"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.19"

  name = var.vpc_name
  cidr = var.vpc_cidr

  azs             = var.availability_zones
  private_subnets = var.private_subnet_cidrs
  public_subnets  = var.public_subnet_cidrs
  map_public_ip_on_launch = true

  
  # NAT Gateway configuration
  enable_nat_gateway     = true
  single_nat_gateway     = local.is_prod
  enable_dns_hostnames   = true
  enable_dns_support     = true

  # VPC Flow Logs
  enable_flow_log                      = local.is_prod
  create_flow_log_cloudwatch_log_group = local.is_prod
  create_flow_log_cloudwatch_iam_role  = local.is_prod
  flow_log_max_aggregation_interval    = 60

  # Disable default resources
  manage_default_security_group  = false
  default_security_group_ingress = []
  default_security_group_egress  = []
  manage_default_route_table    = false
  default_route_table_routes    = []
  manage_default_network_acl    = true

  # Subnet tags for EKS
  private_subnet_tags = var.private_subnet_tags
  public_subnet_tags = var.public_subnet_tags
  tags = var.tags
}

# Security Groups
module "bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.prefix}-bastion"
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

  name        = "${var.prefix}-mongodb"
  description = "Security group for MongoDB instances"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 27017
      to_port     = 27017
      protocol    = "tcp"
      description = "MongoDB from VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    }
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                = "tcp"
      description             = "SSH from bastion"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
  tags         = var.tags
}

module "eks_node_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.3"

  name        = "${var.prefix}-eks-node"
  description = "Security group for EKS node groups"
  vpc_id      = module.vpc.vpc_id

  ingress_with_self = [
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      description = "Node to node all TCP ports"
    }
  ]

  ingress_with_source_security_group_id = [
    {
      from_port                = 22
      to_port                  = 22
      protocol                = "tcp"
      description             = "SSH from bastion"
      source_security_group_id = module.bastion_sg.security_group_id
    }
  ]

  egress_rules = ["all-all"]
  tags         = merge(var.tags, {
    "kubernetes.io/cluster/${var.cluster_name}" = "owned"
  })
}

