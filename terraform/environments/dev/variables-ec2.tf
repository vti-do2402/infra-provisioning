variable "mongodb" {
  description = "MongoDB configuration"
  type = object({
    instance_type  = string
    key_name       = string
    admin_username = string
    admin_password = string
    data_volume    = string
    database       = string
  })
  default = {
    instance_type  = "t2.micro"
    key_name       = "mongodb-key"
    admin_username = "admin"
    admin_password = "password"
    data_volume    = "/home/ec2-user/mongodb-data"
    database       = "mock-project"
  }
}

variable "bastion" {
  description = "Bastion host configuration"
  type = object({
    instance_type        = string
    key_name             = string
    kubectl_version      = string
    kubectl_release_date = string
    arch                 = string
  })
  default = {
    instance_type        = "t2.micro"
    key_name             = "bastion-key"
    kubectl_version      = "1.32.0"
    kubectl_release_date = "2024-12-20"
    arch                 = "amd64"
  }

  validation {
    condition     = can(regex("^t[23]\\.", var.bastion.instance_type))
    error_message = "Instance type must start with t2.micro or t3.micro for cost optimization."
  }
}


