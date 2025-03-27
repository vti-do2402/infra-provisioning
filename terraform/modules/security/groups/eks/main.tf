resource "aws_security_group" "eks_node_group" {
  name        = "${var.name_prefix}-eks-node-group-sg"
  vpc_id      = var.vpc_id
  description = "Security Group for EKS Node Group"

  tags = merge(var.tags, {
    Name = "${var.name_prefix}-eks-node-group-sg"
  })
}

# Node-to-node communication
resource "aws_vpc_security_group_ingress_rule" "node_to_node" {
  security_group_id            = aws_security_group.eks_node_group.id
  referenced_security_group_id = aws_security_group.eks_node_group.id
  description                  = "Allow node-to-node communication"
  from_port                    = 0
  to_port                      = 65535
  ip_protocol                  = "tcp"
  tags                         = var.tags
}

# Control plane communication
resource "aws_vpc_security_group_ingress_rule" "control_plane" {
  security_group_id            = aws_security_group.eks_node_group.id
  referenced_security_group_id = var.cluster_security_group_id
  description                  = "Allow EKS Control Plane to communicate with nodes"
  from_port                    = 443
  to_port                      = 443
  ip_protocol                  = "tcp"
  tags                         = var.tags
}

# Include common outbound rules
module "common_egress" {
  source = "../../rules/common"

  security_group_id = aws_security_group.eks_node_group.id
  tags             = var.tags
}

# Kubelet specific egress
resource "aws_vpc_security_group_egress_rule" "kubelet" {
  security_group_id = aws_security_group.eks_node_group.id
  from_port         = 10250
  to_port           = 10250
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
  description       = "Allow kubelet port"
  tags              = var.tags
} 