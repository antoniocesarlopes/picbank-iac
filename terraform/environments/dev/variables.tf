
variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1" 
}

# Nome do projeto
variable "project" {
  description = "Nome do projeto"
  type        = string
  default     = "picbank"
}

# Bloco CIDR da VPC
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Lista de subnets públicas
variable "public_subnets" {
  description = "Lista de subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "environment" {
  description = "The environment for the ECS service (dev or prod)"
  type        = string
}

variable "image_url" {
  description = "URL da imagem do serviço no ECR"
  type        = string
}

variable "execution_role_arn" {
  description = "ARN do IAM Role de execução do ECS"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnets onde os containers do ECS serão executados"
  type        = list(string)
}

variable "bucket_terraform_state" {
  description = "Nome do bucket S3 para armazenar o estado do Terraform"
  type        = string
}

variable "dynamoDB_terraform_locks" {
  description = "Nome da tabela DynamoDB para bloqueio de concorrência"
  type        = string
}

variable "sqs_wait_time_seconds" {
  description = "Tempo de espera para long polling no SQS"
  type        = number
  default     = 10
}

variable "ses_sender_email" {
  description = "Endereço de e-mail autorizado para envio via SES"
  type        = string
}

