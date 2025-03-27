variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "enable_versioning" {
  description = "Enable versioning for the S3 bucket"
  type        = bool
  default     = false
}

variable "block_public_access" {
  description = "Whether to block all public access to the bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm. Valid values: AES256, aws:kms"
  type        = string
  default     = "AES256"
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for the bucket"
  type = list(object({
    id      = string
    status  = string
    prefix  = optional(string)
    expiration = optional(object({
      days = number
    }))
    transitions = optional(list(object({
      days          = number
      storage_class = string
    })))
  }))
  default = []
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}




