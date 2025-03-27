output "security_group_id" {
  description = "ID of the bastion security group"
  value       = aws_security_group.bastion.id
}

output "security_group_name" {
  description = "Name of the bastion security group"
  value       = aws_security_group.bastion.name
} 