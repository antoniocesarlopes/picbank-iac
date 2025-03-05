# ================================
# SECURITY GROUP PARA ECS
# ================================
resource "aws_security_group" "ecs" {
  vpc_id = var.vpc_id

  tags = {
    Name        = "${var.project}-ecs-sg"
    Environment = var.environment
  }
}

# Regras de entrada para permitir tráfego HTTP (porta 80)
resource "aws_security_group_rule" "ecs_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol         = "tcp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Regras de entrada para permitir tráfego HTTPS (porta 443)
resource "aws_security_group_rule" "ecs_https" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol         = "tcp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Regras de entrada para permitir tráfego na porta do serviço (exemplo: 8080)
resource "aws_security_group_rule" "ecs_service" {
  type              = "ingress"
  from_port         = var.service_port
  to_port           = var.service_port
  protocol         = "tcp"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
}

# Regra de saída: permitir todo tráfego de saída
resource "aws_security_group_rule" "ecs_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol         = "-1"
  security_group_id = aws_security_group.ecs.id
  cidr_blocks       = ["0.0.0.0/0"]
}
