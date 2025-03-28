output "repository_arn" {
  description = "Full ARN of the repository"
  value       = module.main.repository_arn
}

output "repository_registry_id" {
  description = "The registry ID where the repository was created"
  value       = module.main.repository_registry_id
}

output "repository_url" {
  description = "The URL of the repository (in the form aws_account_id.dkr.main.region.amazonaws.com/repositoryName)"
  value       = module.main.repository_url
}

output "repository_name" {
  description = "The name of the repository"
  value       = module.main.repository_name
}


