locals {
  prefix = "${var.tags["Owner"]}-${var.tags["Project"]}-${local.tags["Environment"]}"
  is_dev = local.tags["Environment"] == "dev"
  tags = merge(var.tags, {
    Terraform   = true
    Environment = "dev"
  })
}