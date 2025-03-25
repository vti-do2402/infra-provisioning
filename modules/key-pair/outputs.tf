output "ssh_key_path" {
  description = "Path to the SSH private key"
  value = local_sensitive_file.ssh_private_key.filename
}

output "key_name" {
  value = aws_key_pair.key_pair.key_name
}