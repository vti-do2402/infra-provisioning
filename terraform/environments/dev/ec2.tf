module "bastion" {
  source            = "../../modules/ec2"
  instance_name     = "${local.prefix}-bastion"
  instance_type     = var.bastion.instance_type
  ami_id            = data.aws_ssm_parameter.ubuntu_24_04_ami.value
  subnet_id         = module.networking.public_subnet_ids[0]
  security_group_id = module.security.bastion_security_group_id
  key_name          = var.bastion.key_name # ensure this exists
  user_data         = file("${path.module}/scripts/bastion-startup.sh")

  tags = local.tags
}

module "mongodb" {
  source = "../../modules/ec2"

  instance_name     = "${local.prefix}-mongodb"
  instance_type     = var.mongodb.instance_type
  ami_id            = data.aws_ssm_parameter.ubuntu_24_04_ami.value
  subnet_id         = module.networking.private_subnet_ids[0]
  security_group_id = module.security.mongodb_security_group_id
  key_name          = var.mongodb.key_name # ensure this exists
  user_data = templatefile("${path.module}/scripts/mongodb-startup.sh", {
    mongodb_username       = var.mongodb.username
    mongodb_password       = var.mongodb.password
    mongodb_port           = var.mongodb.port
    mongodb_data_volume    = var.mongodb.data_volume
    mongo_express_port     = "27002"
    docker_compose_version = "1.29.2"
  })
  tags = local.tags
}