# S3 bucket for storing CI/CD Artifacts
locals {
  cicd_bucket_name = "${local.prefix}-cicd-artifacts"
  
  # Lifecycle rules for CI/CD artifacts
  cicd_lifecycle_rules = [
    {
      id      = "cleanup-old-artifacts"
      status  = "Enabled"
      # Delete artifacts after 30 days
      expiration = {
        days = 30
      }
      # Move to IA storage after 7 days
      transitions = [
        {
          days          = 7
          storage_class = "STANDARD_IA"
        }
      ]
    }
  ]
}

# CI/CD artifacts bucket
module "cicd_artifacts_bucket" {
  source = "../../modules/s3"

  bucket_name         = local.cicd_bucket_name
  enable_versioning   = true
  block_public_access = false # Allow public access for dev only
  sse_algorithm       = "AES256"
  lifecycle_rules     = local.cicd_lifecycle_rules

  tags = merge(local.tags, {
    Name = local.cicd_bucket_name
    Role = "cicd"
  })
}