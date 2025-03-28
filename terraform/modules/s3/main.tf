module "s3_bucket" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 4.6"

  bucket = var.bucket_name

  # Security best practices (always block public access)
  block_public_acls       = var.block_public_access
  block_public_policy     = var.block_public_access
  ignore_public_acls      = var.block_public_access
  restrict_public_buckets = var.block_public_access

  # Bucket versioning
  versioning = {
    enabled = var.enable_versioning
  }

  # Server-side encryption (enabled by default with AWS managed key)
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  # Lifecycle rules
  lifecycle_rule = [
    for rule in var.lifecycle_rules : {
      id      = "rule-${rule.prefix}"
      enabled = rule.enabled
      prefix  = rule.prefix
      expiration = rule.expiration
      transition = rule.transition
      filter = rule.filter
    }
  ]


  # Force destroy
  force_destroy = var.force_destroy

  tags = merge(var.tags, {
    Name = var.bucket_name
  })
}