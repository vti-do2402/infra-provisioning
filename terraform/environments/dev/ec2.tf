
locals {
  bastion_key_pair_name = length(module.key_pairs["bastion"].key_pair_name) > 0 ? module.key_pairs["bastion"].key_pair_name : var.bastion.key_name
  mongodb_key_pair_name = length(module.key_pairs["mongodb"].key_pair_name) > 0 ? module.key_pairs["mongodb"].key_pair_name : var.mongodb.key_name

  instance_config = {
    // Bastion host
    bastion = {
      instance_type          = var.bastion.instance_type
      ami                    = data.aws_ssm_parameter.ubuntu_24_04_ami.value
      key_name               = local.bastion_key_pair_name
      monitoring             = !local.is_dev
      vpc_security_group_ids = [module.networking.bastion_security_group_id]
      subnet_id              = module.networking.public_subnets[0]
      user_data              = file("${path.module}/user-data/bastion.sh")
      tags                   = {}
    }
    // MongoDB host
    mongodb = {
      instance_type          = var.mongodb.instance_type
      ami                    = data.aws_ami.amazon_linux.id
      key_name               = local.mongodb_key_pair_name
      monitoring             = !local.is_dev
      vpc_security_group_ids = [module.networking.mongodb_security_group_id]
      subnet_id              = module.networking.private_subnets[0]
      # user_data              = file("${path.module}/user-data/mongodb.sh")
      tags = {}
    }
  }
}

module "ec2_instances" {
  source                      = "terraform-aws-modules/ec2-instance/aws"
  version                     = "~> 5.7"
  for_each                    = local.instance_config
  name                        = "${local.prefix}-${each.key}"
  iam_instance_profile        = data.aws_iam_instance_profile.eks_node_role.name
  instance_type               = each.value.instance_type
  ami                         = each.value.ami
  key_name                    = each.value.key_name
  monitoring                  = each.value.monitoring
  vpc_security_group_ids      = each.value.vpc_security_group_ids
  subnet_id                   = each.value.subnet_id
  user_data                   = ""
  user_data_replace_on_change = !local.is_dev

  tags = merge(local.tags, each.value.tags)
}