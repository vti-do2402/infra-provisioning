output "security_group_id" {
  description = "ID of the MongoDB security group"
  value       = aws_security_group.mongodb.id
}

output "security_group_name" {
  description = "Name of the MongoDB security group"
  value       = aws_security_group.mongodb.name
} 