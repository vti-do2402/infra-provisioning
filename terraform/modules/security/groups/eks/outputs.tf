output "security_group_id" {
  description = "Security group ID of the EKS cluster"
  value       = aws_security_group.eks_node_group.id
}

output "security_group_name" {
  description = "Security group name of the EKS cluster"
  value       = aws_security_group.eks_node_group.name
}
