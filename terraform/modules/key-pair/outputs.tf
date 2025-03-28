output "key_pair_name" {
  description = "Name of the created key pair"
  value       = module.key_pair.key_pair_name
}

output "public_key" {
  description = "The public key of the created key pair"
  value       = module.key_pair.public_key_openssh
}

output "private_key_s3_location" {
  description = "S3 location of the stored private key"
  value = {
    bucket = aws_s3_object.private_key.bucket
    key    = aws_s3_object.private_key.key
  }
}

output "local_private_key_path" {
  description = "Local path to the private key file"
  value       = local_sensitive_file.ssh_private_key.filename
}