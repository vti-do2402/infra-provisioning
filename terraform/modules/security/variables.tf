variable "cluster_name" {
  description = "Name of the cluster (used as prefix for resource names)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where security groups will be created"
  type        = string
}

variable "admin_ip" {
  description = "Set of IP addresses allowed to access the bastion host"
  type        = set(string)
}

variable "cluster_security_group_id" {
  description = "EKS Control Plane security group ID"
  type        = string
}

variable "mongodb_allowed_cidrs" {
  description = "List of additional CIDR blocks allowed to access MongoDB"
  type        = list(string)
  default     = []
}

variable "mongodb_port" {
  description = "Port number for MongoDB"
  type        = number
  default     = 27017
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}