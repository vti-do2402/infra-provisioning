# ECR Module

This module creates an Amazon Elastic Container Registry (ECR) repository with enhanced security features and IAM access controls.

## Features

- Repository configuration with image tag mutability and encryption
- Image scanning on push
- Lifecycle policies for image management
- Fine-grained IAM access controls:
  - Pull access
  - Push access
  - Cross-account access
- Repository policies for access management

## Usage

```hcl
# Example: Basic Repository
module "api_repository" {
  source = "../../modules/ecr"

  repository_name      = "api-service"
  image_tag_mutability = "IMMUTABLE"
  encryption_type      = "AES256"
  scan_on_push        = true
  force_delete        = true # Only for non-production

  # IAM access controls
  pull_principals = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/eks-node-group-role"
  ]

  push_principals = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/github-actions-role"
  ]

  # Optional: Cross-account access
  cross_account_principals = [
    "arn:aws:iam::111111111111:root" # Dev account
  ]

  # Optional: Lifecycle policy
  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Environment = "dev"
    Service     = "api"
  }
}
```

## Requirements

| Name      | Version |
| --------- | ------- |
| terraform | >= 1.0  |
| aws       | ~> 5.0  |

## Providers

| Name | Version |
| ---- | ------- |
| aws  | ~> 5.0  |

## Inputs

| Name                     | Description                                                           | Type           | Default       | Required |
| ------------------------ | --------------------------------------------------------------------- | -------------- | ------------- | :------: |
| repository_name          | Name of the ECR repository                                            | `string`       | n/a           |   yes    |
| image_tag_mutability     | The tag mutability setting for the repository                         | `string`       | `"IMMUTABLE"` |    no    |
| encryption_type          | The encryption type for the repository                                | `string`       | `"AES256"`    |    no    |
| scan_on_push             | Indicates whether images are scanned after being pushed               | `bool`         | `true`        |    no    |
| force_delete             | If true, will delete the repository even if it contains images        | `bool`         | `false`       |    no    |
| lifecycle_policy         | JSON formatted ECR lifecycle policy                                   | `string`       | `null`        |    no    |
| pull_principals          | List of AWS principal ARNs allowed to pull images                     | `list(string)` | `[]`          |    no    |
| push_principals          | List of AWS principal ARNs allowed to push images                     | `list(string)` | `[]`          |    no    |
| cross_account_principals | List of AWS principal ARNs from other accounts allowed to pull images | `list(string)` | `[]`          |    no    |
| tags                     | A map of tags to add to all resources                                 | `map(string)`  | `{}`          |    no    |

## Outputs

| Name                   | Description                                      |
| ---------------------- | ------------------------------------------------ |
| repository_arn         | Full ARN of the repository                       |
| repository_name        | The name of the repository                       |
| repository_url         | The URL of the repository                        |
| repository_registry_id | The registry ID where the repository was created |
| repository_policy_id   | The ID of the repository policy                  |

## Security Features

1. **Image Immutability**: By default, image tags are immutable to prevent overwriting.
2. **Encryption**: AES-256 encryption by default, with option for KMS.
3. **Image Scanning**: Enabled by default for vulnerability detection.
4. **Access Control**: Fine-grained IAM controls for pull, push, and cross-account access.
5. **Lifecycle Management**: Optional lifecycle policies for automated cleanup.

## Best Practices

1. Use immutable tags in production environments.
2. Enable image scanning for security.
3. Implement lifecycle policies to manage storage costs.
4. Use specific IAM roles instead of account root for cross-account access.
5. Tag resources appropriately for cost allocation and management.
