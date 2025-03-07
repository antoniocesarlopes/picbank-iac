# ===================================
# CONFIGURAÇÃO DAS SUBNETS PÚBLICAS
# ===================================

resource "aws_subnet" "public" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.public_subnets[0]  # Apenas um bloco CIDR para a subnet pública.
  map_public_ip_on_launch = true  # As instâncias iniciadas aqui recebem IP público automaticamente.

  tags = {
    Name        = "${var.project}-public-subnet"
    Environment = var.environment
  }
}
