# Local values for reuse throughout
locals {
  project_name = "Rocket Chat Project"
  environment  = var.env
  region       = var.aws_region
  key_name     = var.key_name
  instances = {
    testing-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.instance_type
    }
    nginx-server = {
      ami           = data.aws_ami.ubuntu.id
      instance_type = var.instance_type
    }
  }
}
