resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "local_sensitive_file" "ssh_private_key" {
  content = tls_private_key.ssh_key.private_key_pem
  filename = "${path.root}/.ssh/${var.key_name}.pem"
  file_permission = "0600"
}