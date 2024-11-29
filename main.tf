module "final-project-vpc" {
  source   = "./modules/network"
  vpc_name = var.vpc_name
  env      = var.env
  cidr     = var.vpc_cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false
  key_name           = var.key_name
}

# EC2 Instances
resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = module.devops_vpc.keypair
  subnet_id                   = each.value.subnet_id
  security_groups             = each.value.sg
  associate_public_ip_address = true

  root_block_device {
    volume_size           = var.instance_storage
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name        = each.key
    Project     = local.project_name
    Environment = local.environment
  }
}
