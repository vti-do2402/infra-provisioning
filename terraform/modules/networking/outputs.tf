output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "vpc_name" {
  description = "The name of the VPC"
  value       = module.vpc.name
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}

output "public_subnet_cidrs" {
  description = "List of CIDRs of public subnets"
  value       = module.vpc.public_subnets_cidr_blocks
}

output "private_subnet_cidrs" {
  description = "List of CIDRs of private subnets"
  value       = module.vpc.private_subnets_cidr_blocks
} 

output "nat_public_ips" {
  description = "List of public Elastic IPs created for AWS NAT Gateway"
  value       = module.vpc.nat_public_ips
}

# Security Group outputs
output "bastion_security_group_id" {
  description = "ID of the bastion host security group"
  value       = module.bastion_sg.security_group_id
}

output "mongodb_security_group_id" {
  description = "ID of the MongoDB security group"
  value       = module.mongodb_sg.security_group_id
}

output "eks_node_security_group_id" {
  description = "ID of the EKS node security group"
  value       = module.eks_node_sg.security_group_id
}