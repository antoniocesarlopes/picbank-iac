variable "vpc_id" {
  description = "ID da VPC onde o Security Group será criado"
  type        = string
}

variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "Ambiente de implantação (dev, prod, etc.)"
  type        = string
}

variable "service_port" {
  description = "Porta onde o serviço estará rodando (ex: 8080)"
  type        = number
}
