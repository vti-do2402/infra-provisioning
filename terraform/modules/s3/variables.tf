variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "block_public_access" {
  description = "Whether to block public access to the bucket"
  type        = bool
  default     = true
}

variable "enable_versioning" {
  description = "Enable versioning on the bucket"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "The server-side encryption algorithm to use"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.sse_algorithm)
    error_message = "Invalid SSE algorithm. Must be one of: AES256, KMS"
  }
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules for cost optimization"
  type = list(object({
    prefix          = string
    enabled         = bool
    expiration = object({
      days = number
    })
    transition = list(object({
      days = number
      storage_class = string
    }))
    filter = list(object({
      prefix = optional(string, "")
      tags = optional(map(string), {})
    }))
  }))
  default = []
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket (delete all objects)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}




