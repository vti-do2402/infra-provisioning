provider "aws" {
  region = "us-west-2"
}

module "s3" {
  source = "../modules/s3"

  bucket_name = "${local.tags.Owner}-${local.tags.Project}-terraform-state"
  block_public_access = false
  enable_versioning = true
  sse_algorithm = "AES256"
  lifecycle_rules = [
    {
      id = "terraform-state-lifecycle-rule"
      status = "Enabled"
      expiration = {
        days = 30
      }
      transition = {
        days = 30
      }
    }
  ]

  tags = local.tags
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name         = "${local.tags.Owner}-${local.tags.Project}-terraform-state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = local.tags
}

