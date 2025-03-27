variable "name_prefix" {
  description = "Prefix to use for resource names"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the security group will be created"
  type        = string
}

variable "allowed_cidr_blocks" {
  description = "List of CIDR blocks allowed to access MongoDB"
  type        = set(string)
  default     = []
}

variable "mongodb_port" {
  description = "Port number for MongoDB"
  type        = number
  default     = 27017
}

variable "bastion_security_group_id" {
  description = "ID of the bastion host security group"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 