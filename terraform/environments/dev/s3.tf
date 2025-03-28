# S3 bucket for storing CI/CD Artifacts
locals {
  // Common transition rules for all buckets
  transition_rules = [
    {
      days          = 30
      storage_class = "STANDARD_IA"
    },
    {
      days          = 60
      storage_class = "GLACIER"
    }
  ]

  bucket_config = {
    // Bucket for storing CI/CD artifacts
    artifacts = {
      bucket_name         = "${local.prefix}-artifacts"
      enable_versioning   = true
      sse_algorithm       = "AES256"
      block_public_access = true
      lifecycle_rules = [
        {
          id      = "ci-artifacts"
          enabled = true
          prefix  = "artifacts/"
          filter = [{
            tags = {
              Role = "cicd"
            }
          }]
          transition = local.transition_rules
          expiration = {
            days = 90
          }
        }
      ]
      tags = {
        Role = "cicd"
      }
    }
    // Bucket for storing private keys
    private_key = {
      bucket_name         = "${local.prefix}-private-key"
      enable_versioning   = false
      sse_algorithm       = "AES256"
      block_public_access = true
      lifecycle_rules     = []
      tags = {
        Role = "private-key"
      }
    }
  }
}

module "s3_buckets" {
  source   = "../../modules/s3"
  for_each = local.bucket_config

  bucket_name         = each.value.bucket_name
  enable_versioning   = each.value.enable_versioning
  sse_algorithm       = each.value.sse_algorithm
  block_public_access = each.value.block_public_access
  lifecycle_rules     = each.value.lifecycle_rules
  tags                = merge(local.tags, each.value.tags)
}
