# Common HTTPS egress rule
resource "aws_vpc_security_group_egress_rule" "https" {
  count = var.allow_all_outbound ? 0 : 1
  security_group_id = var.security_group_id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS egress"
  tags              = var.tags
}

# Common DNS rules
resource "aws_vpc_security_group_egress_rule" "dns" {
  count = var.allow_all_outbound ? 0 : 1
  for_each = toset(["tcp", "udp"])

  security_group_id = var.security_group_id
  from_port         = 53
  to_port           = 53
  ip_protocol       = each.key
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow DNS over ${each.key}"
  tags              = var.tags
}

# Optional: Allow all outbound traffic
resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  count = var.allow_all_outbound ? 1 : 0

  security_group_id = var.security_group_id
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow all outbound traffic"
  tags              = var.tags
} 