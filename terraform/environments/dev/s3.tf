# S3 bucket for storing CI/CD Artifacts
locals {
  cicd_bucket_name = "${local.prefix}-cicd-artifacts"
  
  # Lifecycle rules for CI/CD artifacts
  cicd_lifecycle_rules = [
    {
      id     = "cleanup-old-artifacts"
      status = "Enabled"
      prefix = "artifacts/"  # Only apply to artifacts directory
      expiration = { days = 30 }
      transitions = [
        { days = 7, storage_class = "STANDARD_IA" }
      ]
    },
    {
      id     = "cleanup-old-logs"
      status = "Enabled"
      prefix = "logs/"  # Only apply to logs directory
      expiration = { days = 90 } 
      transitions = [
        { days = 30, storage_class = "STANDARD_IA" },
        { days = 60, storage_class = "GLACIER" }
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