# ================================
# NETWORK ACL (NACL) PÚBLICA
# ================================

resource "aws_network_acl" "public" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-public-nacl"
    Environment = var.environment
  }
}

# ================================
# REGRAS DE ENTRADA PARA A NACL PÚBLICA
# ================================

# Permite tráfego HTTP de entrada (porta 80)
resource "aws_network_acl_rule" "http_inbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 80
  to_port        = 80
}

# Permite tráfego HTTPS de entrada (porta 443)
resource "aws_network_acl_rule" "https_inbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 110
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 443
  to_port        = 443
}

# Permite tráfego SSH de entrada (porta 22) - Opcional, apenas se necessário para acesso remoto
resource "aws_network_acl_rule" "ssh_inbound" {
  count          = var.allow_ssh ? 1 : 0
  network_acl_id = aws_network_acl.public.id
  rule_number    = 120
  protocol       = "tcp"
  rule_action    = "allow"
  egress         = false
  cidr_block     = "0.0.0.0/0"
  from_port      = 22
  to_port        = 22
}

# ================================
# REGRAS DE SAÍDA PARA A NACL PÚBLICA
# ================================

# Permite saída de todo o tráfego (porta 0-65535)
resource "aws_network_acl_rule" "outbound" {
  network_acl_id = aws_network_acl.public.id
  rule_number    = 100
  protocol       = "-1"
  rule_action    = "allow"
  egress         = true
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

# ===================================
# ASSOCIAÇÃO DA NACL ÀS SUBNETS PÚBLICAS
# ===================================

resource "aws_network_acl_association" "public" {
  count          = length(var.public_subnet_ids)
  network_acl_id = aws_network_acl.public.id
  subnet_id      = var.public_subnet_ids[count.index]
}
