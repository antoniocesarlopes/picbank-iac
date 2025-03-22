variable "vpc_id" {
  description = "ID da VPC onde as subnets serão criadas"
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

variable "public_subnets" {
  description = "Lista de blocos CIDR para as subnets públicas"
  type        = list(string)
}
