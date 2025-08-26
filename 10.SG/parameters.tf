
resource "aws_ssm_parameter" "bastion_sg_id" {
  name  = "/${var.project}/${var.environment}/bastion_sg_id"
  type  = "String"
  value = module.bastion.sg_id
}


resource "aws_ssm_parameter" "ingress_alb_sg_id" {
  name  = "/${var.project}/${var.environment}/ingress-ALB_sg_id"
  type  = "String"
  value = module.ingress_ALB_SG.sg_id
}


resource "aws_ssm_parameter" "eks_control_plane_sg_id" {
  name  = "/${var.project}/${var.environment}/eks_control_plane_sg_id"
  type  = "String"
  value = module.eks_control_plane_SG.sg_id
}

resource "aws_ssm_parameter" "eks_nodes_sg_id" {
  name  = "/${var.project}/${var.environment}/eks_nodes_sg_id"
  type  = "String"
  value = module.eks_nodes_SG.sg_id
}

