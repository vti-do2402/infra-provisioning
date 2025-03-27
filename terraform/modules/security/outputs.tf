output "eks_security_group_id" {
  description = "EKS security group ID"
  value       = module.eks_node_group.security_group_id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value       = module.bastion.security_group_id
}

output "mongodb_security_group_id" {
  description = "MongoDB security group ID"
  value       = module.mongodb.security_group_id
}
