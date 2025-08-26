
module "bastion" {
  #source = "../../terraform-securitygroup-module"
  source = "git::https://github.com/Mahachopperla/terraform-securitygroup-module.git?ref=main"
  sg_name = var.bastion_sg_name
  sg_description = var.bastion_sg_description
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

}

module "ingress_ALB_SG" {
  #source = "../../terraform-securitygroup-module"
  source = "git::https://github.com/Mahachopperla/terraform-securitygroup-module.git?ref=main"
  sg_name = "ingress-ALB-sg"
  sg_description = "creating ingress ALB"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

module "eks_control_plane_SG" {
  #source = "../../terraform-securitygroup-module"
  source = "git::https://github.com/Mahachopperla/terraform-securitygroup-module.git?ref=main"
  sg_name = "eks-controlplane-SG"
  sg_description = "creating eks-controlplane-SG"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

module "eks_nodes_SG" {
  #source = "../../terraform-securitygroup-module"
  source = "git::https://github.com/Mahachopperla/terraform-securitygroup-module.git?ref=main"
  sg_name = "eks-nodes-SG"
  sg_description = "creating eks-nodes-SG"
  project = var.project
  environment = var.environment
  vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  
}

# module "VPN-SG" {
#   source = "../../terraform-securitygroup-module"
#   sg_name = var.vpn_sg_name
#   sg_description = var.vpn_sg_description
#   project = var.project
#   environment = var.environment
#   vpc_id = data.aws_ssm_parameter.vpc_id.value # we will get the value of ssm parameter id and it will be assigned to variable vpc_id 
  

# }

# eks control plane accepting all traffic from eks nodes from all ports

resource "aws_security_group_rule" "eks-control-plane_eks-nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"  # all protocols
  source_security_group_id = module.eks_nodes_SG.sg_id  # EKS node SG
  security_group_id        = module.eks_control_plane_SG.sg_id

}

# eks control plane should accept https connections from bastion

resource "aws_security_group_rule" "eks-control-plane_bastion_https" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"  # all protocols
  source_security_group_id = module.bastion.sg_id  # EKS node SG
  security_group_id        = module.eks_control_plane_SG.sg_id

}

# similarly eks nodes should accept all traffic from eks control plane

resource "aws_security_group_rule" "eks-nodes_eks-control-plane" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"  # all protocols
  source_security_group_id = module.eks_control_plane_SG.sg_id  # EKS control plane SG
  security_group_id        = module.eks_nodes_SG.sg_id 

}

# eks nodes should allow ssh from bastion

resource "aws_security_group_rule" "eks-nodes_bastion_ssh" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"  # all protocols
  source_security_group_id = module.bastion.sg_id  # bastion SG
  security_group_id        = module.eks_nodes_SG.sg_id 

}

# worker nodes should allow internal traffic within the nodes. As we cant' determine exact ip's of worker nodes, we are alowing worker nodes communication within vpc cidr

resource "aws_security_group_rule" "eks-nodes_eks-nodes" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"  # all protocols
  cidr_blocks              = [ "10.0.0.0/16" ]  # vpc-cidr
  security_group_id        = module.eks_nodes_SG.sg_id 

}  


#frontend ALB

# frontend ALB accepting https connections from internet

resource "aws_security_group_rule" "ingress-ALB-https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ] # frontend needs to accept connections from internet securely(443 for security - https)
  security_group_id = module.ingress_ALB_SG.sg_id

}


# bastion accepting connections from my laptop
resource "aws_security_group_rule" "bastion-inbound" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = [ "0.0.0.0/0" ]
  security_group_id = module.bastion.sg_id

}



