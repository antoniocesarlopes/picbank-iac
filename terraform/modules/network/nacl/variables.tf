variable "vpc_id" {
  description = "ID da VPC onde a NACL será criada"
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

variable "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas associadas à NACL"
  type        = list(string)
}

variable "allow_ssh" {
  description = "Define se o tráfego SSH (porta 22) será permitido"
  type        = bool
  default     = false
}
