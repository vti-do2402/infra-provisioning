terraform {
  backend "s3" {
    bucket = "quentin-mock-project-terraform-state"
    key    = "global/terraform.tfstate"
    region = "us-west-2"
    dynamodb_table = "quentin-mock-project-terraform-state-lock"
    encrypt = true
  }
}