# ===================================
# CONFIGURAÇÃO DAS SUBNETS PÚBLICAS
# ===================================

resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[count.index]
  map_public_ip_on_launch = true  # As instâncias iniciadas aqui recebem IP público automaticamente.

  tags = {
    Name        = "${var.project}-public-subnet-${count.index}"
    Environment = var.environment
  }
}

# ===================================
# CONFIGURAÇÃO DAS SUBNETS PRIVADAS
# ===================================

resource "aws_subnet" "private" {
  count      = length(var.private_subnets)
  vpc_id     = var.vpc_id
  cidr_block = var.private_subnets[count.index]

  tags = {
    Name        = "${var.project}-private-subnet-${count.index}"
    Environment = var.environment
  }
}
