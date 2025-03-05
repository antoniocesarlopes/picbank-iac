# Exporta a URL do repositório no ECR para ser usada no ECS
output "repository_url" {
  description = "URL do repositório ECR onde a imagem do auth-service será armazenada"
  value       = "${aws_ecr_repository.auth_service.repository_url}:${var.image_tag}"
}
