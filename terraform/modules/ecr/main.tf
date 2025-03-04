# ===========================
# ECR: REPOSITÓRIO PARA A IMAGEM DO AUTH-SERVICE
# ===========================

# Cria um repositório no Amazon ECR para armazenar a imagem do auth-service
resource "aws_ecr_repository" "auth_service" {
  name = "${var.project}-auth-service"  # Define um nome descritivo para o repositório

  # Habilita a verificação automática de vulnerabilidades na imagem ao ser enviada
  image_scanning_configuration {
    scan_on_push = true  # Ativa a verificação de segurança na imagem
  }

  tags = {
    Name        = "${var.project}-auth-service"
    Environment = "dev"  # Define o ambiente
  }
}
