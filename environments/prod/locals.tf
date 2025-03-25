locals {
  prefix          = "${var.tags["Owner"]}-${var.tags["Project"]}-${local.tags["Environment"]}"
  azs             = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets  = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i)]
  private_subnets = [for i, az in local.azs : cidrsubnet(var.vpc_cidr, 8, i + 3)]

  tags = merge(var.tags, {
    Terraform   = true
    Environment = "prod"
  })
}