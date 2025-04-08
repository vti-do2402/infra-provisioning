# Create ECR repositories for each service
module "ecr_repositories" {
  source   = "../../modules/ecr"
  for_each = jsondecode(file("${path.module}/user-data/repositories.json"))

  repository_name      = "${local.prefix}/${each.value.name}"
  image_tag_mutability = local.is_dev ? "MUTABLE" : "IMMUTABLE"
  encryption_type      = "AES256"
  scan_on_push         = !local.is_dev
  force_delete         = local.is_dev
  # lifecycle_policy     = templatefile("${path.module}/user-data/policies-ecr.json", {})
  push_principals      = [module.iam.iam_role_arn]
  pull_principals      = [module.eks.cluster_iam_role_arn]
  tags = merge(local.tags, each.value.tags)
}