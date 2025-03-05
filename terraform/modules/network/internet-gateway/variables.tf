variable "vpc_id" {
  description = "ID da VPC onde o Internet Gateway será criado"
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
