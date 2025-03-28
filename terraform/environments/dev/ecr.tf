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

  # Standard lifecycle policy for all repositories
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Remove untagged images after 14 days"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 14
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# Create ECR repositories for each service
module "ecr_repositories" {
  source   = "../../modules/ecr"
  for_each = local.ecr_config

  repository_name      = "${local.prefix}/${each.value.name}"
  image_tag_mutability = local.is_dev ? "MUTABLE" : "IMMUTABLE"
  encryption_type      = "AES256"
  scan_on_push         = !local.is_dev
  force_delete         = local.is_dev
  lifecycle_policy     = local.lifecycle_policy

  tags = merge(local.tags, each.value.tags)
}