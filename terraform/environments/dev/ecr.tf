locals {
  # Define standard configuration for all repositories
  ecr_config = {
    api_gateway = {
      name = "api-gateway"
      tags = { Service = "api-gateway" }
    }
    backend_service = {
      name = "backend-service"
      tags = { Service = "backend-service" }
    }
    ui_service = {
      name = "ui-service"
      tags = { Service = "ui-service" }
    }
    database_service = {
      name = "database-service"
      tags = { Service = "database-service" }
    }
  }
}

module "ecr_repositories" {
  source   = "../../modules/ecr"
  for_each = local.ecr_config

  repository_name      = "${local.prefix}/${each.value.name}"
  image_tag_mutability = "IMMUTABLE" # Prevent tag overwriting for security
  encryption_type      = "AES256"
  scan_on_push         = true
  force_delete         = true # Allow repository deletion with images (for dev only)

  tags = merge(local.tags, each.value.tags)
}