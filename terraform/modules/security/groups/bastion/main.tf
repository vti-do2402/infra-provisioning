resource "aws_security_group" "bastion" {
  name        = "${var.name_prefix}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for Bastion Host"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-bastion-sg"
  })
}

# Allow SSH from Admin IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_bastion" {
  for_each = var.admin_ip

  security_group_id = aws_security_group.bastion.id
  description       = "Allow SSH from admin IP"
  cidr_ipv4         = each.value
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags              = var.tags
}

module "common_egress" {
  source = "../../rules/common"

  security_group_id = aws_security_group.bastion.id
  allow_all_outbound = true
  tags             = var.tags
}
