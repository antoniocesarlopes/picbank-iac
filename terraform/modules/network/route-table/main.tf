# ===================================
# TABELA DE ROTAS PÚBLICA
# ===================================
resource "aws_route_table" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-public-route-table"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Rota para permitir saída para a internet via Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.internet_gateway_id
}

# Associação da tabela de rotas pública às subnets públicas
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet_ids)
  subnet_id      = var.public_subnet_ids[count.index]
  route_table_id = aws_route_table.public.id
}
