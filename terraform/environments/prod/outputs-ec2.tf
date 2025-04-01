output "ec2_instances" {
  description = "EC2 instances"
  value = {
    for name, instance in module.ec2_instances : name => {
      id         = instance.id
      public_ip  = instance.public_ip
      private_ip = instance.private_ip
    }
  }
}
