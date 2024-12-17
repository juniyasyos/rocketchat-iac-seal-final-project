# Local values for reuse throughout
# Local values for reuse throughout
locals {
  project_name            = "Rocket Chat Project"
  environment             = var.env
  region                  = var.aws_region
  key_name                = var.key_name
  default_vpc_cidr        = "10.100.0.0/16"
  default_private_subnets = ["10.100.210.0/24", "10.100.220.0/24", "10.100.230.0/24"]
  default_public_subnets  = ["10.100.110.0/24", "10.100.120.0/24", "10.100.130.0/24"]

  resolved_vpc_cidr        = var.vpc_cidr != "" ? var.vpc_cidr : local.default_vpc_cidr
  resolved_private_subnets = length(var.private_subnets) > 0 ? var.private_subnets : local.default_private_subnets
  resolved_public_subnets  = length(var.public_subnets) > 0 ? var.public_subnets : local.default_public_subnets
  instances = {
    testing_server = {
      ami           = data.aws_ami.ubuntu.id
      sg            = [aws_security_group.frontend.id]
      instance_type = var.instance_type_micro
    }
    nginx_server = {
      ami           = data.aws_ami.ubuntu.id
      sg            = [aws_security_group.frontend.id]
      instance_type = var.instance_type_app
    }
    monitoring_server = {
      ami           = data.aws_ami.ubuntu.id
      sg            = [aws_security_group.frontend.id]
      instance_type = var.instance_type_micro
    }
    db_server = {
      ami           = data.aws_ami.ubuntu.id
      sg            = [aws_security_group.backend.id]
      instance_type = "t2.large"
    }
  }
}
