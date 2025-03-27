# ECR Repository Module
# Manages ECR repositories with security and lifecycle configurations

resource "aws_ecr_repository" "main" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
  
  encryption_configuration {
    encryption_type = var.encryption_type
  }

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  # Force delete images when destroying repository
  force_delete = var.force_delete

  tags = var.tags
}