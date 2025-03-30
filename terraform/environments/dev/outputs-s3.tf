output "s3_buckets" {
  description = "S3 bucket details for CI/CD artifacts"
  value = {
    for bucket in module.s3_buckets : bucket.bucket_id => {
      name = bucket.bucket_id
    }
  }
}