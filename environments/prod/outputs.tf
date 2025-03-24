output "vpc_id" {
  description = "VPC ID"
  value       = module.networking.vpc_id
}

output "private_subnets" {
  description = "Private subnet IDs"
  value       = module.networking.private_subnet_ids
}

output "public_subnets" {
  description = "Public subnet IDs"
  value       = module.networking.public_subnet_ids
}

output "ecr_reposotitory" {
  description = "The URL of the repository"
  value       = module.ecr.ecr_repository_url
}

# output "cluster_endpoint" {
#   description = "EKS cluster endpoint"
#   value       = module.eks.cluster_endpoint
# }

# output "cluster_name" {
#   description = "EKS cluster name"
#   value       = module.eks.cluster_name
# }

output "bastion" {
  description = "Bastion host information"
  value = {
    instance_id  = module.bastion.instance_id
    public_ip    = module.bastion.public_ip
    private_ip   = module.bastion.private_ip
    ssh_key_path = module.bastion.ssh_key_path
  }
}

