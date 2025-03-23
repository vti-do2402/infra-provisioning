variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "public_access_cidrs" {
  description = "CIDR blocks to allow public access"
  type = set(string)
  default = [ "0.0.0.0/0" ]
}

variable "security_group_ids" {
  description = "List of ID of security groups to attach to the EKS cluster"
  type = set(string)
  default = []
}

variable "node_groups" {
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
}

variable "tags" {
  description = "Tags"
  type        = map(string)
  default     = {}
}