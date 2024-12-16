# Frontend Security Group
resource "aws_security_group" "frontend" {
  vpc_id = module.final-project-vpc.vpc_id

  # HTTP untuk private subnets
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
  }

  ingress {
    from_port = 0
    to_port   = 65535
    protocol  = "tcp"
    self      = true
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = var.public_subnets
  }

  # Akses terbatas pada IP spesifik untuk berbagai port
  dynamic "ingress" {
    for_each = { for port in [3000, 3030, 9000, 9090, 9099] : port => var.ip_secure }
    content {
      from_port   = ingress.key
      to_port     = ingress.key
      protocol    = "tcp"
      cidr_blocks = ingress.value
    }
  }

  # SSH hanya untuk IP tertentu
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_secure
  }

  # Mengizinkan ICMP (ping) dari subnet lokal dalam VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.public_subnets
  }

  # Semua lalu lintas keluar diperbolehkan
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

# Backend Security Group
resource "aws_security_group" "backend" {
  vpc_id = module.final-project-vpc.vpc_id

  # Port MongoDB Server
  ingress {
    from_port   = 27017
    to_port     = 27017
    protocol    = "tcp"
    cidr_blocks = var.public_subnets
  }

  # SSH hanya untuk IP tertentu
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_secure
  }

  # Mengizinkan ICMP (ping) antar instance di VPC
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = var.public_subnets
  }

  # Semua lalu lintas keluar diperbolehkan
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
