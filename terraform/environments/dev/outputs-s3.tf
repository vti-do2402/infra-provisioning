output "cicd_artifacts_bucket" {
  description = "S3 bucket details for CI/CD artifacts"
  value = {
    name                 = module.cicd_artifacts_bucket.bucket_id
    arn                  = module.cicd_artifacts_bucket.bucket_arn
    domain_name          = module.cicd_artifacts_bucket.bucket_domain_name
    regional_domain_name = module.cicd_artifacts_bucket.bucket_regional_domain_name
  }
}