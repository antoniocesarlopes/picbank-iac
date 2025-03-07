# URL da imagem do serviço no ECR
variable "image_url" {
  description = "URL da imagem armazenada no ECR"
  type        = string
}

# ARN do IAM Role de execução do ECS
variable "execution_role_arn" {
  description = "ARN da IAM Role usada pelo ECS para execução de tarefas"
  type        = string
}

# Lista de subnets para o ECS
variable "subnet_id" {
  description = "subnet onde os containers do ECS serão executados"
  type        = string
}

# Nome do projeto
variable "project" {
  description = "Nome do projeto"
  type        = string
}

# Região da AWS onde o ECS será provisionado
variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados"
  type        = string
}

variable "environment" {
  description = "The environment for the ECS service (dev or prod)"
  type        = string
}

variable "security_group_id" {
  description = "ID do grupo de segurança para o serviço ECS"
  type        = string
}
