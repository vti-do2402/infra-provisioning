terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  required_version = ">= 1.3.0"
}

provider "aws" {
  region = var.region
}

# VPC Module
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "quentin-mock-project-small-vpc"
  cidr = "10.0.0.0/16"

  azs                = [var.availability_zone]
  public_subnets     = ["10.0.1.0/24"]
  map_public_ip_on_launch = true
  enable_nat_gateway = false
  single_nat_gateway = false
}

# EC2 Instance Module
module "runner" {
  source = "../modules/compute"

  instance_name     = "quentin-mock-project-github-runner"
  instance_type     = "t2.micro"
  ami_id            = data.aws_ami.ubuntu.id
  subnet_id         = module.vpc.public_subnets[0]
  key_name          = var.key_name
  security_group_id = module.sg.security_group_id
  user_data         = file("${path.module}/scripts/runner-startup.sh")
}

# Ubuntu AMI (Latest Ubuntu 24.04)
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Security Group for EC2
module "sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.1.0"

  name        = "runner-ssh-access"
  description = "Allow SSH access"
  vpc_id      = module.vpc.vpc_id

  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = [var.admin_ip] # e.g., "YOUR_IP/32"

  egress_rules = ["all-all"]
}
