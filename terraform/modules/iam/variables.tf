variable "aws_account_id" {
  type        = string
  description = "The AWS account ID to use for the action"
}

variable "iam_role" {
  type        = string
  description = "Self-hosted runner EC2 instance role"
}

variable "aws_region" {
  type        = string
  description = "The AWS region to use for the action"
  default     = "us-west-2"
}


