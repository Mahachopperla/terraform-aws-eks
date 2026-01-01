resource "aws_ssm_parameter" "dev-vpc_id" {
  name  = "/${var.main_project}/${var.main_environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}


resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.main_project}/${var.main_environment}/public_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)

}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.main_project}/${var.main_environment}/private_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.private_subnet_ids)

}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.main_project}/${var.main_environment}/database_subnet_ids"
  type  = "StringList"
  value = join(",", module.vpc.database_subnet_ids)

}

