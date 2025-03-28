output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.main.cluster_endpoint
}

output "cluster_name" {
  description = "The name/id of the EKS cluster"
  value       = module.main.cluster_id
}

output "cluster_security_group_id" {
  description = "Security group ID attached to the EKS cluster"
  value       = module.main.cluster_security_group_id
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks --region ${data.aws_region.current.name} update-kubeconfig --name ${module.main.cluster_name}"
}

# Get current region
data "aws_region" "current" {}

output "cluster_iam_role_arn" {
  description = "ARN of the EKS cluster role"
  value       = module.main.cluster_iam_role_arn
}

output "node_iam_role_arn" {
  description = "ARN of the EKS node role"
  value       = module.main.node_iam_role_arn
}