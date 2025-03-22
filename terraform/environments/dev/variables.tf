variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados"
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "Nome do projeto"
  type        = string
  default     = "picbank"
}

variable "cidr_block" {
  description = "Bloco CIDR para a VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnets" {
  description = "Lista de blocos CIDR para as subnets públicas"
  type        = list(string)
}

variable "environment" {
  description = "O ambiente onde os recursos serão implantados (dev ou prod)"
  type        = string
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

variable "service_port" {
  description = "Porta onde o serviço estará rodando (ex: 8080)"
  type        = number
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
