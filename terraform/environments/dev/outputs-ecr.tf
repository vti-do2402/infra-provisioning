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