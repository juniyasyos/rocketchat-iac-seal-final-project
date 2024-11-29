# Public Subnets
resource "aws_subnet" "public_1" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.100.110.0/24"
  availability_zone = module.vpc.azs[0]

  tags = {
    Name = "${var.vpc_name}-public-1"
    Tier = "public"
    Env  = var.env
  }
}

resource "aws_subnet" "public_2" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.100.120.0/24"
  availability_zone = module.vpc.azs[1]

  tags = {
    Name = "${var.vpc_name}-public-2"
    Tier = "public"
    Env  = var.env
  }
}

resource "aws_subnet" "public_3" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.100.130.0/24"
  availability_zone = module.vpc.azs[2]

  tags = {
    Name = "${var.vpc_name}-public-3"
    Tier = "public"
    Env  = var.env
  }
}

# Private Subnets
resource "aws_subnet" "private_1" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.100.210.0/24"
  availability_zone = module.vpc.azs[0]

  tags = {
    Name = "${var.vpc_name}-private-1"
    Tier = "private"
    Env  = var.env
  }
}

resource "aws_subnet" "private_2" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id
  cidr_block = "10.100.220.0/24"
  availability_zone = module.vpc.azs[1]

  tags = {
    Name = "${var.vpc_name}-private-2"
    Tier = "private"
    Env  = var.env
  }
}

# EIP for NAT Gateway
resource "aws_eip" "nat_1" {
  domain = "vpc"
}

resource "aws_eip" "nat_2" {
  domain = "vpc"
}

# NAT Gateways
resource "aws_nat_gateway" "nat_1" {
  depends_on    = [module.vpc]
  subnet_id     = aws_subnet.public_1.id
  allocation_id = aws_eip.nat_1.id

  tags = {
    Name = "${var.vpc_name}-nat-gateway-1"
    Env  = var.env
  }
}

resource "aws_nat_gateway" "nat_2" {
  depends_on    = [module.vpc]
  subnet_id     = aws_subnet.public_2.id
  allocation_id = aws_eip.nat_2.id

  tags = {
    Name = "${var.vpc_name}-nat-gateway-2"
    Env  = var.env
  }
}

# Route Tables
resource "aws_route_table" "public" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.vpc.igw_id
  }

  tags = {
    Name = "${var.vpc_name}-public-route-table"
    Env  = var.env
  }
}

resource "aws_route_table" "private" {
  depends_on = [module.vpc]
  vpc_id     = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_1.id
  }

  tags = {
    Name = "${var.vpc_name}-private-route-table"
    Env  = var.env
  }
}

# Route Table Associations
resource "aws_route_table_association" "public_1" {
  subnet_id      = aws_subnet.public_1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_2" {
  subnet_id      = aws_subnet.public_2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_3" {
  subnet_id      = aws_subnet.public_3.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.private_1.id
  route_table_id = aws_route_table.private.id
}

resource "aws_route_table_association" "private_2" {
  subnet_id      = aws_subnet.private_2.id
  route_table_id = aws_route_table.private.id
}

# Security Groups
resource "aws_security_group" "frontend" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-frontend-sg"
    Env  = var.env
  }
}

resource "aws_security_group" "backend" {
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.vpc_name}-backend-sg"
    Env  = var.env
  }
}

