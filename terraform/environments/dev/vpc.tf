locals {
  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets   = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets  = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 10)]
  database_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 20)]
  intra_subnets    = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 30)]

  aws_account_id = data.aws_caller_identity.current.account_id
}

module "networking" {
  source = "../../modules/networking"

  vpc_name = local.prefix
  prefix   = local.prefix
  vpc_cidr = var.vpc_cidr
  // If var null, use local values
  availability_zones    = var.availability_zones == null ? local.azs : var.availability_zones
  public_subnet_cidrs   = var.public_subnet_cidrs == null ? local.public_subnets : var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs == null ? local.private_subnets : var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs == null ? local.database_subnets : var.database_subnet_cidrs
  intra_subnet_cidrs    = var.intra_subnet_cidrs == null ? local.intra_subnets : var.intra_subnet_cidrs

  cluster_name    = "${local.prefix}-${var.cluster_name}"
  admin_ip_ranges = var.admin_ip_ranges
  private_subnet_tags = merge(
    local.tags,
    {
      "kubernetes.io/role/internal-elb"           = 1
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
  public_subnet_tags = merge(
    local.tags,
    {
      "kubernetes.io/role/elb"                    = 1
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  })
  database_subnet_tags = merge(
    local.tags,
    {
      "kubernetes.io/role/internal-elb"           = 1
      "kubernetes.io/cluster/${var.cluster_name}" = "shared"
      "kubernetes.io/role/cni"                    = 1
    }
  )


  tags = local.tags
}

module "iam" {
  source = "../../modules/iam"

  aws_account_id = local.aws_account_id
  iam_role       = "github-actions-role"
  aws_region     = var.aws_region
}

