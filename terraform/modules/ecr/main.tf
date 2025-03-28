module "main" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "~> 2.3"

  repository_name = var.repository_name

  # Repository configuration
  repository_type                 = "private"
  repository_image_tag_mutability = var.image_tag_mutability
  repository_encryption_type      = var.encryption_type
  repository_force_delete        = var.force_delete

  # Image scanning
  repository_image_scan_on_push = var.scan_on_push

  # Access management
  repository_read_write_access_arns = var.push_principals
  repository_read_access_arns       = var.pull_principals
  repository_lifecycle_policy = var.lifecycle_policy

  tags = var.tags
}