variable "bastion_sg_name" {
  type = string
  default = "bastion"
}

variable "bastion_sg_description" {
  type = string
  default = "Created sg for bastion instance"
}

variable "ALB_sg_name" {
  type = string
  default = "ALB-SG"
}

variable "ALB_sg_description" {
  type = string
  default = "Created sg for Application Load Balancer"
}



variable "project" {
    type = string
    default = "roboshop"
  
}

variable "environment" {
    type = string
    default = "dev"
  
}

