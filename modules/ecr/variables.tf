variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "Specify the tag mutability setting to use. When tag immutability is turned on for a repository, tags are prevented from being overwritten. Valid values are MUTABLE or IMMUTABLE"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = var.image_tag_mutability == "MUTABLE" || var.image_tag_mutability == "IMMUTABLE"
    error_message = "image_tag_mutability must be either MUTABLE or IMMUTABLE"
  }
}

variable "encryption_type" {
  description = "The encryption type to use for the repository. Valid values are AES256 or KMS"
  type        = string
  default     = "AES256"
  validation {
    condition     = var.encryption_type == "AES256" || var.encryption_type == "KMS"
    error_message = "encryption_type must be either AES256 or KMS"
  }
}

variable "scan_on_push" {
  description = "Indicates whether images are scanned after being pushed to the repository"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for the ECR repository"
  type        = map(string)
  default     = {}
}