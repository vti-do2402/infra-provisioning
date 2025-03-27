resource "aws_security_group" "mongodb" {
  name        = "${var.name_prefix}-mongodb-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for MongoDB (Docker) instance"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-mongodb-sg"
  })
}

# Allow MongoDB access from specified CIDR blocks
resource "aws_vpc_security_group_ingress_rule" "allow_mongodb" {
  for_each = var.allowed_cidr_blocks

  security_group_id = aws_security_group.mongodb.id
  description       = "Allow MongoDB access from ${each.value}"
  cidr_ipv4         = each.value
  from_port         = var.mongodb_port
  ip_protocol       = "tcp"
  to_port           = var.mongodb_port
  tags              = var.tags
}

# Allow SSH from bastion
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_from_bastion" {
  security_group_id            = aws_security_group.mongodb.id
  description                  = "Allow SSH from bastion host"
  referenced_security_group_id = var.bastion_security_group_id
  from_port                    = 22
  ip_protocol                  = "tcp"
  to_port                      = 22
  tags                         = var.tags
}

module "common_egress" {
  source = "../../rules/common"

  security_group_id = aws_security_group.mongodb.id
  tags             = var.tags
}
