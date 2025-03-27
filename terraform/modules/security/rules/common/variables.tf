variable "security_group_id" {
  description = "ID of the security group to attach rules to"
  type        = string
}

variable "allow_all_outbound" {
  description = "Whether to allow all outbound traffic"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 