output "ecs_cluster_name" {
  description = "Nome do cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nome do serviço ECS"
  value       = aws_ecs_service.auth_service.name
}

output "image_url" {
  description = "URL da imagem armazenada no ECR"
  value       = var.image_url
  
}

# ARN do IAM Role de execução do ECS
output "execution_role_arn" {
  description = "ARN da IAM Role usada pelo ECS para execução de tarefas"
  value = var.execution_role_arn
}