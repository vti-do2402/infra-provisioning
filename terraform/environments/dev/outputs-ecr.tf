# ECR Repository Outputs
# -----------------------------
# These outputs will be used by CI/CD pipelines to push Docker images

output "ecr_repositories" {
  description = "ECR repository details for all microservices"
  value = {
    for k, v in module.ecr_repositories : k => {
      url  = v.repository_url
      name = v.repository_name
      arn  = v.repository_arn
    }
  }
}

# Individual repository URLs for direct reference
output "api_gateway_repository_url" {
  description = "ECR repository URL for API Gateway service"
  value       = module.ecr_repositories["api_gateway"].repository_url
}

output "backend_service_repository_url" {
  description = "ECR repository URL for Backend service"
  value       = module.ecr_repositories["backend_service"].repository_url
}

output "ui_service_repository_url" {
  description = "ECR repository URL for UI service"
  value       = module.ecr_repositories["ui_service"].repository_url
}

output "database_service_repository_url" {
  description = "ECR repository URL for Database service"
  value       = module.ecr_repositories["database_service"].repository_url
} 