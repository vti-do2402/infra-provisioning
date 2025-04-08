# IAM policy for GitHub Actions role
resource "aws_iam_role" "github_actions" {
  name = var.iam_role

  assume_role_policy = jsonencode(
    {
      Version = "2012-10-17"
      Statement = [
        {
          Effect = "Allow"
          Action = "sts:AssumeRoleWithWebIdentity"
          Principal = {
            Federated = "arn:aws:iam::${var.aws_account_id}:oidc-provider/token.actions.githubusercontent.com"
          }
          Condition = {
            StringEquals = {
              "token.actions.githubusercontent.com:aud" : [
                "sts.amazonaws.com"
              ]
            },
            StringLike = {
              "token.actions.githubusercontent.com:sub" : [
                "repo:vti-do2402/*"
              ]
            }
          }
        }
      ]
    }
  )
}

resource "aws_iam_openid_connect_provider" "github_actions" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com"
  ]
}

# Separate policy for ECR authorization
resource "aws_iam_role_policy" "ecr_auth" {
  name = "ECRAuthorization"
  role = aws_iam_role.github_actions.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["ecr:GetAuthorizationToken"]
      # Resource = "arn:aws:ecr:${var.aws_region}:${var.aws_account_id}:repository/*"
      Resource = "*"
    }]
  })
}