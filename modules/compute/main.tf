resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  user_data = var.user_data

  tags = merge(var.tags, {
    Name = var.instance_name
  })
}