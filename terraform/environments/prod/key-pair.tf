locals {
  key_pairs = {
    bastion = {
      key_name = var.bastion.key_name
    }
    mongodb = {
      key_name = var.mongodb.key_name
    }
  }
}

module "key_pairs" {
  source = "../../modules/key-pair"

  for_each = local.key_pairs

  key_name              = each.value.key_name
  private_key_s3_bucket = module.s3_buckets["private_key"].bucket_id
  private_key_s3_key    = local.tags["Environment"]
  tags                  = local.tags
}

output "key_pairs" {
  description = "Key pairs"
  value = {
    for key_pair in module.key_pairs : key_pair.key_pair_name => {
      key_name = key_pair.key_pair_name
      bucket   = key_pair.private_key_s3_location.bucket
      key      = key_pair.private_key_s3_location.key
    }
  }
}