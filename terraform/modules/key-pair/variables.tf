variable "key_name" {
  description = "SSH key name for the instance"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the key pair"
  type        = map(string)
  default     = {}
}

variable "private_key_s3_bucket" {
  description = "Name of the S3 bucket to store the private key"
  type        = string
}

variable "private_key_s3_key" {
  description = "S3 key path for storing the private key"
  type        = string
  default     = "ssh-keys/private-keys"
}