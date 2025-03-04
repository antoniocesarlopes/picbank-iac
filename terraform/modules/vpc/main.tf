# ========================
# CONFIGURAÇÃO DA REDE VPC
# ========================

# Criação da VPC (Virtual Private Cloud), que servirá como a rede principal para o ambiente.
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block  # Define o bloco CIDR da VPC, especificado na variável.
  enable_dns_support   = true            # Habilita suporte a DNS para resolução de serviços AWS internos.
  enable_dns_hostnames = true            # Permite que instâncias dentro da VPC recebam hostnames públicos.

  tags = {
    Name = "${var.project}-vpc"  # Nome da VPC para fácil identificação no console da AWS.
  }
}

# ========================
# CONFIGURAÇÃO DAS SUBNETS
# ========================

# Criação de subnets públicas dentro da VPC.
# O uso do "count" permite criar múltiplas subnets baseadas na lista var.public_subnets.
resource "aws_subnet" "public" {
  count                   = length(var.public_subnets)  # Número de subnets a serem criadas, com base na variável.
  vpc_id                  = aws_vpc.main.id            # Associa cada subnet à VPC criada anteriormente.
  cidr_block              = var.public_subnets[count.index]  # Define o bloco CIDR de cada subnet.
  map_public_ip_on_launch = true  # Garante que instâncias iniciadas nessas subnets tenham IPs públicos automaticamente.

  tags = {
    Name = "${var.project}-public-subnet-${count.index}"  # Nomeia cada subnet para fácil identificação.
  }
}

# ================================
# CONFIGURAÇÃO DO INTERNET GATEWAY
# ================================

# Criação do Internet Gateway (IGW), que permite que a VPC tenha acesso à internet.
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id  # Vincula o Internet Gateway à VPC.

  tags = {
    Name = "${var.project}-igw"  # Nome do Internet Gateway para fácil identificação.
  }
}

# ===================================
# CONFIGURAÇÃO DA TABELA DE ROTAS PÚBLICA
# ===================================

# Criação de uma tabela de rotas pública, que será usada pelas subnets públicas para acessar a internet.
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id  # Associa a tabela de rotas à VPC.

  tags = {
    Name = "${var.project}-public-route-table"  # Nome para identificação no console da AWS.
  }
}

# ===================================
# CONFIGURAÇÃO DA ROTA PARA INTERNET
# ===================================

# Adiciona uma rota na tabela de rotas pública para permitir tráfego externo.
resource "aws_route" "default" {
  route_table_id         = aws_route_table.public.id  # Associa essa rota à tabela de rotas pública.
  destination_cidr_block = "0.0.0.0/0"  # Define que todo tráfego de saída será permitido.
  gateway_id             = aws_internet_gateway.gw.id  # O tráfego será direcionado pelo Internet Gateway.
}

# ===================================
# ASSOCIAÇÃO DA TABELA DE ROTAS ÀS SUBNETS PÚBLICAS
# ===================================

# Associa a tabela de rotas pública a todas as subnets públicas criadas.
resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)  # Itera sobre todas as subnets públicas.
  subnet_id      = aws_subnet.public[count.index].id  # Associa cada subnet pública à tabela de rotas pública.
  route_table_id = aws_route_table.public.id  # Define que essa subnet utilizará a tabela de rotas pública.
}

