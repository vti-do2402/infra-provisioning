output "repository_url" {
  description = "The URL of the repository"
  value       = aws_ecr_repository.main.repository_url
}

output "repository_name" {
  description = "The name of the repository"
  value       = aws_ecr_repository.main.name
}

output "repository_arn" {
  description = "The ARN of the repository. For use in IAM policies."
  value = aws_ecr_repository.main.arn
}


