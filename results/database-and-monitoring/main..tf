module "final-project-vpc" {
  source   = "../../modules/network"
  vpc_name = var.vpc_name
  env      = var.env
  cidr     = local.resolved_vpc_cidr

  azs             = var.azs
  private_subnets = local.resolved_private_subnets
  public_subnets  = local.resolved_public_subnets

  enable_nat_gateway = true
  enable_vpn_gateway = false
  key_name           = var.key_name
}

# EC2 Instances
resource "aws_instance" "this" {
  for_each                    = local.instances
  ami                         = each.value.ami
  instance_type               = each.value.instance_type
  key_name                    = module.final-project-vpc.keypair
  subnet_id                   = module.final-project-vpc.public_subnets[0]
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

resource "aws_eip" "eip" {
  for_each = local.instances

  domain   = "vpc"
  instance = aws_instance.this[each.key].id

  tags = {
    Name        = "${each.key}-eip"
    Project     = local.project_name
    Environment = local.environment
  }
}


resource "local_file" "env_file" {
  content = join("\n", [
    for instance, eip in aws_eip.eip :
    "${upper(instance)}_EIP=${eip.public_ip}\n${upper(instance)}_DNS=${eip.public_dns}"
  ])
  filename = "${path.module}/ip_elastic.env"
}
