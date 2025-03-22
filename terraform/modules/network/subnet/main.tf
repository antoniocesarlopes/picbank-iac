# ===================================
# CONFIGURAÇÃO DAS SUBNETS PÚBLICAS
# ===================================

resource "aws_subnet" "public_1" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[0]
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true  # As instâncias iniciadas aqui recebem IP público automaticamente.

  tags = {
    Name        = "${var.project}-public-subnet-1"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[1]
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true  # As instâncias iniciadas aqui recebem IP público automaticamente.

  tags = {
    Name        = "${var.project}-public-subnet-2"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}