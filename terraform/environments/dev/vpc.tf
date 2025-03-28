module "networking" {
  source = "../../modules/networking"

  vpc_name             = local.prefix
  prefix               = local.prefix
  vpc_cidr             = var.vpc_cidr
  availability_zones   = length(var.availability_zones) > 0 ? var.availability_zones : local.azs
  public_subnet_cidrs  = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : local.public_subnets
  private_subnet_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : local.private_subnets
  cluster_name         = "${local.prefix}-${var.cluster_name}"
  admin_ip_ranges      = var.admin_ip_ranges
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

  tags = local.tags
}