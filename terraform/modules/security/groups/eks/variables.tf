variable "name_prefix" {
  description = "Prefix for the security group name"
  type        = string
}


variable "vpc_id" {
  description = "VPC ID"
  type        = string
}


variable "cluster_security_group_id" {
  description = "Security group ID of the EKS cluster"
  type        = string
}

variable "bastion_security_group_id" {
  description = "Security group ID of the Bastion host"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the security group"
  type        = map(string)
}
