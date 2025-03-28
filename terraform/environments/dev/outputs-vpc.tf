output "vpc" {
  description = "VPC details"
  value = {
    id              = module.networking.vpc_id
    public_subnets  = module.networking.public_subnets
    private_subnets = module.networking.private_subnets
  }
}

output "security_groups" {
  description = "Security groups details"
  value = {
    bastion = module.networking.bastion_security_group_id
    mongodb = module.networking.mongodb_security_group_id
  }
}