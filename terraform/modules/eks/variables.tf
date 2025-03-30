variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version to use for the EKS cluster (e.g., `1.27`)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster will be provisioned"
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the EKS cluster and nodes will be provisioned"
  type        = list(string)
}

variable "control_plane_subnet_ids" {
  description = "A list of subnet IDs where the EKS control plane will be provisioned"
  type        = list(string)
  default     = []
}

variable "node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type = map(object({
    ami_type       = optional(string, "AL2_x86_64")
    instance_types = list(string)
    capacity_type  = optional(string, "ON_DEMAND")
    disk_size      = optional(number, 50)
    min_size       = number
    max_size       = number
    desired_size   = number
    labels         = optional(map(string), {})
  }))
  default = {}
}

variable "enable_public_access" {
  description = "Enable public API server endpoint access"
  type        = bool
  default     = false
}

variable "enable_private_access" {
  description = "Enable private API server endpoint access"
  type        = bool
  default     = true
}

variable "public_access_cidrs" {
  description = "List of CIDR blocks that can access the EKS public API server endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_security_group_id" {
  description = "ID of the security group for the EKS cluster"
  type        = string
  default     = null
}

variable "cluster_security_group_additional_rules" {
  description = "Additional security group rules to add to the EKS cluster"
  type        = any
  default = null
}

variable "node_security_group_id" {
  description = "ID of the security group for the EKS nodes"
  type        = string
  default     = null
}

variable "node_security_group_additional_rules" {
  description = "Additional security group rules to add to the EKS nodes"
  type        = any
  default = null
}

variable "bastion_security_group_id" {
  description = "ID of the security group for the bastion host"
  type        = string
  default     = null
}



variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}