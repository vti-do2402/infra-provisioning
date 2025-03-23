module "networking" {
  source               = "../../modules/networking"
  vpc_cidr             = var.vpc_cidr
  cluster_name         = "${local.prefix}-${var.cluster_name}"
  availability_zones   = length(var.availability_zones) > 0 ? var.availability_zones : local.azs
  public_subnet_cidrs  = length(var.public_subnet_cidrs) > 0 ? var.public_subnet_cidrs : local.public_subnets
  private_subnet_cidrs = length(var.private_subnet_cidrs) > 0 ? var.private_subnet_cidrs : local.private_subnets

  tags = local.tags
}

module "security" {
  source                    = "../../modules/security"
  vpc_id                    = module.networking.vpc_id
  cluster_name              = "${local.prefix}-${var.cluster_name}"
  admin_ip                  = var.admin_ip
  cluster_security_group_id = module.eks.cluster_security_group_id

  tags = local.tags
}

module "ecr" {
  source          = "../../modules/ecr"
  repository_name = "${local.prefix}-repo"
  tags            = local.tags
}

module "eks" {
  source = "../../modules/eks"

  depends_on          = [module.bastion]
  cluster_name        = "${local.prefix}-${var.cluster_name}"
  cluster_version     = var.cluster_version
  vpc_id              = module.networking.vpc_id
  subnet_ids          = module.networking.private_subnet_ids
  public_access_cidrs = [var.admin_ip, "${module.bastion.public_ip}/32"] # only allow kubelet access from bastion host or admin IP
  security_group_ids  = [module.security.eks_security_group_id]
  node_groups         = var.node_groups

  tags = local.tags
}

module "bastion" {
  source            = "../../modules/compute"
  instance_name     = "${local.prefix}-bastion"
  instance_type     = var.bastion.instance_type
  ami_id            = data.aws_ssm_parameter.ubuntu_24_04_ami.value
  subnet_id         = module.networking.public_subnet_ids[0]
  security_group_id = module.security.bastion_security_group_id
  key_name          = var.bastion.key_name
  user_data         = file("${path.module}/scripts/bastion-startup.sh")

  tags = local.tags
}