# ===================================
# CONFIGURAÇÃO DO INTERNET GATEWAY (IGW)
# ===================================

# Criação do Internet Gateway
resource "aws_internet_gateway" "this" {
  vpc_id = var.vpc_id  # Vincula o Internet Gateway à VPC informada

  tags = {
    Name        = "${var.project}-igw"
    Environment = var.environment
  }
}
