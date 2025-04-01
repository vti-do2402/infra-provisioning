data "aws_availability_zones" "available" {}

# data "aws_ssm_parameter" "ubuntu_24_04_ami" {
#   name = "/aws/service/canonical/ubuntu/server/24.04/stable/current/amd64/hvm/ebs-gp3/ami-id"
# }

# + AMIs = {
#     + al2023            = "amazon"
#     + al2023_name       = "al2023-ami-2023.6.20250317.2-kernel-6.1-x86_64"
#     + rhel_9            = "amazon"
#     + rhel_9_name       = "RHEL-9.5.0_HVM-20250313-x86_64-0-Hourly2-GP3"
#     + ubuntu_24_04      = "amazon"
#     + ubuntu_24_04_name = "ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-20250305"
#   }

data "aws_ami" "ubuntu_24_04" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }

}

data "aws_ami" "rhel_9" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "name"
    values = ["RHEL-9.5.0_HVM-*-x86_64-*"]
  }
}

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-kernel-*-x86_64"]
  }
}

data "aws_caller_identity" "current" {}

