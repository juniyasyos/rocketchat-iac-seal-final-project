# Retrieve VPC ID
resource "aws_vpc" "rocket_chat" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "rocket-chat-stag"
  }
}

# Create public subnets in two availability zones
resource "aws_subnet" "public" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.rocket_chat.id
  cidr_block             = var.public_subnets[count.index]
  availability_zone      = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name          = "public-subnet-${count.index + 1}"
    Environment   = "elb-dev"
  }
}

# Create ELB-specific public subnets
resource "aws_subnet" "public_elb" {
  count = length(var.azs)

  vpc_id                  = aws_vpc.rocket_chat.id
  cidr_block             = var.public_subnets_elb[count.index]
  availability_zone      = var.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name          = "public-subnet-elb-${count.index + 1}"
    Environment   = "elb-dev"
  }
}