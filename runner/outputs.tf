output "runner" {
  value = {
    public_ip = module.runner.public_ip
    private_ip = module.runner.private_ip
  }
}