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

  # HTTPS terbuka untuk publik (hanya jika endpoint ini publik)
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Akses terbatas pada IP spesifik untuk berbagai port
  dynamic "ingress" {
    for_each = [3000, 3030, 9000, 9090, 9099]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      # cidr_blocks = var.ip_secure
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  # SSH hanya untuk IP tertentu
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    # cidr_blocks = var.ip_secure
    cidr_blocks = ["0.0.0.0/0"]
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

  # Referensi antar security group untuk backend
  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  # Port backend (8000) hanya dapat diakses oleh frontend SG
  ingress {
    from_port       = 8000
    to_port         = 8000
    protocol        = "tcp"
    security_groups = [aws_security_group.frontend.id]
  }

  # SSH hanya untuk IP tertentu
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ip_secure
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
