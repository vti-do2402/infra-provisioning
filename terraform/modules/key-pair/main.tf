# Create key pair using official AWS module
module "key_pair" {
  source  = "terraform-aws-modules/key-pair/aws"
  version = "~> 2.0"

  key_name           = var.key_name
  create_private_key = true
  private_key_algorithm = "RSA"
  private_key_rsa_bits = 4096
  
  tags = var.tags
}

# Store private key in S3 with encryption
resource "aws_s3_object" "private_key" {
  bucket  = var.private_key_s3_bucket
  key     = "${var.private_key_s3_key}/${var.key_name}.pem"
  content = module.key_pair.private_key_pem
  
  server_side_encryption = "AES256"
  
  tags = merge(var.tags, {
    Name = "${var.key_name}-private-key"
  })
}

# Optionally save private key locally for development
resource "local_sensitive_file" "ssh_private_key" {
  content         = module.key_pair.private_key_pem
  filename        = "${path.root}/.ssh/${var.key_name}.pem"
  file_permission = "0600"
}