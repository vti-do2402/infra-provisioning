output "s3_buckets" {
  description = "S3 bucket details for CI/CD artifacts"
  value = {
    for bucket in module.s3_buckets : bucket.bucket_id => {
      name                 = bucket.bucket_id
      arn                  = bucket.bucket_arn
      domain_name          = bucket.bucket_domain_name
      regional_domain_name = bucket.bucket_regional_domain_name
      hosted_zone_id       = bucket.bucket_hosted_zone_id
      region               = bucket.bucket_region
    }
  }
}