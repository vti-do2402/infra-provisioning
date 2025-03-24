variable "region" {
  description = "AWS region"
  default     = "us-west-2"
}

variable "availability_zone" {
  description = "AZ to use for subnet"
  default     = "us-west-2a"
}

variable "key_name" {
  description = "EC2 key pair name"
  type        = string
}

variable "admin_ip" {
  description = "CIDR block for SSH access (e.g., 1.2.3.4/32)"
  type        = string
}
