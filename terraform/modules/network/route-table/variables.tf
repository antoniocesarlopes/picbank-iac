variable "vpc_id" {
  description = "ID da VPC onde as tabelas de rotas serão criadas"
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

variable "internet_gateway_id" {
  description = "ID do Internet Gateway para acesso público"
  type        = string
}

variable "public_subnet_id" {
  description = "ID da subnet pública"
  type        = string
}
