output "bastion" {
  description = "Bastion host information"
  value = {
    instance_id = module.bastion.instance_id
    public_ip   = module.bastion.public_ip
    private_ip  = module.bastion.private_ip
    subnet_id   = module.bastion.subnet_id
  }
}

output "mongodb" {
  description = "MongoDB information"
  value = {
    instance_id = module.mongodb.instance_id
    public_ip   = module.mongodb.public_ip
    private_ip  = module.mongodb.private_ip
    subnet_id   = module.mongodb.subnet_id
  }
}