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
  for_each      = local.instances
  ami           = each.value.ami
  instance_type = each.value.instance_type
  key_name      = module.final-project-vpc.keypair
  # subnet_id                   = each.value.subnet_id
  subnet_id                   = module.final-project-vpc.public_subnets[0]
  security_groups             = module.final-project-vpc.frontend_ids
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

module "elastic_beanstalk" {
  source         = "./modules/elastic_beanstalk"
  env            = var.env
  instance_type  = var.instance_type
  mongodb_url    = var.mongodb_url
  root_url       = var.root_url
}

module "s3_storage" {
  source = "./modules/storage"
  env    = var.env
}