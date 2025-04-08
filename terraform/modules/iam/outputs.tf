output "iam_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github_actions.arn
}

output "oidc_provider_thumbprint" {
  value = aws_iam_openid_connect_provider.github_actions.thumbprint_list
}

# output "policy_document_ecr" {
#   value = data.aws_iam_policy_document.ecr_policy.json
# }



