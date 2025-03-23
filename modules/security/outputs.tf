output "eks_security_group_id" {
  description = "EKS security group ID"
  value = aws_security_group.eks_node_group.id
}

output "bastion_security_group_id" {
  description = "Bastion security group ID"
  value = aws_security_group.bastion.id
}