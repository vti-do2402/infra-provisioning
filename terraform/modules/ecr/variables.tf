variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository. Must be one of: MUTABLE or IMMUTABLE"
  type        = string
  default     = "IMMUTABLE"

  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE."
  }
}

variable "encryption_type" {
  description = "The encryption type for the repository. Must be one of: AES256 or KMS"
  type        = string
  default     = "AES256"

  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Encryption type must be either AES256 or KMS."
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "force_delete" {
  description = "If true, will delete the repository even if it contains images"
  type        = bool
  default     = false
}

variable "lifecycle_policy" {
  description = "JSON formatted ECR lifecycle policy"
  type        = string
  default     = null
}

variable "pull_principals" {
  description = "List of AWS principal ARNs allowed to pull images"
  type        = list(string)
  default     = []
}

variable "push_principals" {
  description = "List of AWS principal ARNs allowed to push images"
  type        = list(string)
  default     = []
}

variable "cross_account_principals" {
  description = "List of AWS principal ARNs from other accounts allowed to pull images"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}