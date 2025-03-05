# ========================
# CONFIGURAÇÃO DA REDE VPC
# ========================

# Criação da VPC (Virtual Private Cloud), que servirá como a rede principal para o ambiente.
resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block  # Define o bloco CIDR da VPC.
  enable_dns_support   = true            # Habilita suporte a DNS para resolução de serviços AWS internos.
  enable_dns_hostnames = true            # Permite que instâncias dentro da VPC recebam hostnames públicos.

  tags = {
    Name        = "${var.project}-vpc"  # Nome da VPC para fácil identificação no console da AWS.
    Environment = var.environment       # Tag de ambiente (dev, prod, etc.).
  }
}
