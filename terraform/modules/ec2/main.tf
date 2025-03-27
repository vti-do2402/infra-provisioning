resource "aws_instance" "ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  iam_instance_profile   = var.iam_instance_profile

  # Enforce IMDSv2
  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type          = var.root_volume_type
    encrypted            = true
    delete_on_termination = true
  }

  # Additional EBS volume for data (optional)
  dynamic "ebs_block_device" {
    for_each = var.additional_ebs_volumes
    content {
      device_name           = ebs_block_device.value.device_name
      volume_size           = ebs_block_device.value.volume_size
      volume_type          = ebs_block_device.value.volume_type
      encrypted            = true
      delete_on_termination = ebs_block_device.value.delete_on_termination
    }
  }

  user_data = var.user_data

  monitoring = var.enable_detailed_monitoring

  tags = merge(var.tags, {
    Name = var.instance_name
  })

}