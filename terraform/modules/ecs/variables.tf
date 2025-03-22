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
variable "subnet_ids" {
  description = "Lista de subnets onde os containers do ECS serão executados"
  type        = list(string)
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

# Cognito
variable "cognito_user_pool_id" {
  description = "ID do User Pool do AWS Cognito"
  type        = string
}

variable "cognito_client_id" {
  description = "ID do Client do AWS Cognito"
  type        = string
}

variable "cognito_client_secret" {
  description = "Client Secret do AWS Cognito"
  type        = string
}

variable "cognito_issuer_uri" {
  description = "Issuer URI do AWS Cognito"
  type        = string
}

variable "cognito_user_pool_arn" {
  description = "ARN do User Pool Cognito"
  type        = string
}

variable "cognito_jwk_set_uri" {
  description = "JWK Set URI do AWS Cognito"
  type        = string
}

# SQS
variable "sqs_queue_url_user_data_request" {
  description = "URL da fila do SQS"
  type        = string
}

variable "sqs_dlq_url_user_data_request" {
  description = "URL da Dead Letter Queue do SQS"
  type        = string
}

variable "sqs_queue_url_user_group_assignment" {
  description = "URL da fila do SQS"
  type        = string
}

variable "sqs_dlq_url_user_group_assignment" {
  description = "URL da Dead Letter Queue do SQS"
  type        = string
}

variable "sqs_queue_url_user_data_response" {
  description = "URL da fila do SQS"
  type        = string
}

variable "sqs_dlq_url_user_data_response" {
  description = "URL da Dead Letter Queue do SQS"
  type        = string
}

# SES
variable "ses_sender_email" {
  description = "Email do remetente configurado no SES"
  type        = string
}

variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type        = string
  sensitive = true
}

variable "aws_secret_access_key" {
  description = "AWS Secret Access Key"
  type        = string
  sensitive = true
}