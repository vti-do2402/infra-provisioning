output "bucket_id" {
  description = "The name of the bucket"
  value       = module.s3_bucket.s3_bucket_id
}

output "bucket_arn" {
  description = "The ARN of the bucket"
  value       = module.s3_bucket.s3_bucket_arn
}

output "bucket_domain_name" {
  description = "The bucket domain name"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "bucket_regional_domain_name" {
  description = "The bucket region-specific domain name"
  value       = module.s3_bucket.s3_bucket_bucket_domain_name
}

output "bucket_hosted_zone_id" {
  description = "The Route 53 Hosted Zone ID for this bucket's region"
  value       = module.s3_bucket.s3_bucket_hosted_zone_id
}

output "bucket_region" {
  description = "The AWS region this bucket resides in"
  value       = module.s3_bucket.s3_bucket_region
}
