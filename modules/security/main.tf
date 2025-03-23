# Security Group: EKS Node Group
resource "aws_security_group" "eks_node_group" {
  name        = "${var.cluster_name}-eks-node-group-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for EKS Node Group"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-eks-node-group-sg"
  })
}

# Security Group: Bastion Host
resource "aws_security_group" "bastion" {
  name        = "${var.cluster_name}-bastion-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for Bastion Host"

  tags = merge(var.tags, {
    Name = "${var.cluster_name}-bastion-sg"
  })
}

######################
### INGRESS RULES ####
######################

# Bastion: Allow SSH from Admin IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_to_bastion" {
  security_group_id = aws_security_group.bastion.id
  description       = "Allow SSH from admin IP"
  cidr_ipv4         = var.admin_ip
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
  tags              = var.tags
}

# EKS Node Group: Allow node-to-node communication (self-referencing SG)
resource "aws_vpc_security_group_ingress_rule" "node_to_node" {
  security_group_id            = aws_security_group.eks_node_group.id
  referenced_security_group_id = aws_security_group.eks_node_group.id
  description                  = "Allow node-to-node communication"
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  tags                         = var.tags
}

# EKS Node Group: Allow EKS control plane to communicate with nodes
resource "aws_vpc_security_group_ingress_rule" "eks_control_plane_to_nodes" {
  security_group_id = aws_security_group.eks_node_group.id
  referenced_security_group_id = var.cluster_security_group_id
  description       = "Allow EKS Control Plane to communicate with nodes"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  tags              = var.tags
}

######################
### EGRESS RULES #####
######################

# Bastion: Allow all traffic to the internet
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4_from_bastion" {
    security_group_id = aws_security_group.bastion.id
    from_port = 0
    to_port = 0
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
    description = "Allow all traffic to the Internet"
    tags = var.tags
}

# Bastion: Allow all traffic to the internet
resource "aws_vpc_security_group_egress_rule" "allow_all_ipv6_from_bastion" {
    security_group_id = aws_security_group.bastion.id
    from_port = 0
    to_port = 0
    ip_protocol = "-1"
    cidr_ipv6 = "::/0"
    description = "Allow all traffic to the Internet"
    tags = var.tags
}

# # ENode Egress: Allow all traffic to the internet
# resource "aws_vpc_security_group_egress_rule" "allow_all_ipv4_from_eks" {
#     security_group_id = aws_security_group.eks_node_group.id
#     from_port = 0
#     to_port = 0
#     ip_protocol = "-1"
#     cidr_ipv4 = "0.0.0.0/0"
#     description = "Allow all traffic to the Internet"
#     tags = var.tags
# }

# # ENode Egress: Allow all traffic to the internet
# resource "aws_vpc_security_group_egress_rule" "allow_all_ipv6_from_eks" {
#     security_group_id = aws_security_group.eks_node_group.id
#     from_port = 0
#     to_port = 0
#     ip_protocol = "-1"
#     cidr_ipv6 = "::/0"
#     description = "Allow all traffic to the Internet"
#     tags = var.tags
# }

# Node Egress: Allow HTTPS
resource "aws_vpc_security_group_egress_rule" "node_egress_https" {
  security_group_id = aws_security_group.eks_node_group.id
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow HTTPS egress"
  tags              = var.tags
}

# Node Egress: Allow kubelet traffic (port 10250)
resource "aws_vpc_security_group_egress_rule" "node_egress_kubelet" {
  security_group_id = aws_security_group.eks_node_group.id
  from_port         = 10250
  to_port           = 10250
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow kubelet port"
  tags              = var.tags
}

# Node Egress: Allow DNS TCP
resource "aws_vpc_security_group_egress_rule" "node_egress_dns_tcp" {
  security_group_id = aws_security_group.eks_node_group.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow DNS over TCP"
  tags              = var.tags
}

# Node Egress: Allow DNS UDP
resource "aws_vpc_security_group_egress_rule" "node_egress_dns_udp" {
  security_group_id = aws_security_group.eks_node_group.id
  from_port         = 53
  to_port           = 53
  ip_protocol       = "udp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow DNS over UDP"
  tags              = var.tags
}