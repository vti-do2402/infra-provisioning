# ECR Repository Outputs
# -----------------------------
# These outputs will be used by CI/CD pipelines to push Docker images

output "ecr_repositories" {
  description = "ECR repository details for all microservices"
  value = {
    for k, v in module.ecr_repositories : k => {
      url  = v.repository_url
      name = v.repository_name
      # arn         = v.repository_arn
      # registry_id = v.repository_registry_id
      login_command = "aws ecr get-login-password --region ${var.aws_region} | docker login --username AWS --password-stdin ${v.repository_url}"
    }
  }
}
