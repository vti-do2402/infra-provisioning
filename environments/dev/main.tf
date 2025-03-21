module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = var.vpc_cidr
  cluster_name         = "${local.prefix}-${var.cluster_name}"
  availability_zones   = length(var.availability_zones) > 0 ? var.availability_zones : local.azs
  public_subnet_cidrs  = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : local.public_subnets
  private_subnet_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : local.private_subnets
  admin_ip             = var.admin_ip
  tags                 = local.tags

}

