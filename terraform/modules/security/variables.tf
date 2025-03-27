variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "admin_ip" {
  description = "IP address to allow SSH access"
  type        = set(string)
}

variable "cluster_security_group_id" {
  description = "EKS Control Plane security group ID"
  type        = string
}

variable "tags" {
  description = "Tags for the EC2 instance"
  type        = map(string)
  default     = {}
}