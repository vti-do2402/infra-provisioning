variable "mongodb" {
  description = "MongoDB configuration"
  type = object({
    username    = string
    password    = string
    port        = number
    data_volume = string
    mongo_express = object({
      port = number
    })
  })
  default = {
    username    = "admin"
    password    = "password"
    port        = 27017
    data_volume = "/data/db"
    mongo_express = {
      port = 8081
    }
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


