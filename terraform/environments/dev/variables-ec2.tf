variable "mongodb" {
  description = "MongoDB configuration"
  type = object({
    instance_type = string
    key_name      = string
    username      = string
    password      = string
    port          = number
    data_volume   = string
  })
  default = {
    username      = "admin"
    password      = "password"
    port          = 27017
    data_volume   = "/home/ec2-user/mongodb-data"
    instance_type = "t2.micro"
    key_name      = "mongodb-key"
  }
}

variable "docker_compose_version" {
  description = "Docker Compose version"
  type        = string
  default     = "2.34.0" // Latest version on 2025-03-14
  validation {
    condition     = can(regex("^\\d+\\.\\d+\\.\\d+$", var.docker_compose_version))
    error_message = "Docker Compose version must be in the format X.Y.Z"
  }
}

variable "bastion" {
  description = "Bastion host configuration"
  type = object({
    instance_type = string
    key_name      = string
  })
  default = {
    instance_type = "t2.micro"
    key_name      = "bastion-key"
  }

  validation {
    condition     = can(regex("^t[23]\\.", var.bastion.instance_type))
    error_message = "Instance type must start with t2.micro or t3.micro for cost optimization."
  }
}


