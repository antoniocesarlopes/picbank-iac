# ===================================
# TABELA DE ROTAS PÚBLICA
# ===================================
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-public-route-table"
    Environment = var.environment
  }
}

# Rota para permitir saída para a internet via Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Associar a route table à única subnet pública
resource "aws_route_table_association" "public" {
  subnet_id      = var.public_subnet_id
  route_table_id = aws_route_table.public.id
}
