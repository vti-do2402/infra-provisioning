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
    data_volume   = "mongodb-data"
    instance_type = "t2.micro"
    key_name      = "bastion-key"
  }
}



variable "docker_compose_version" {
  description = "Docker Compose version"
  type        = string
  default     = "1.29.2"
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
}


