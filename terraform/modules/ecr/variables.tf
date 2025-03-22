# Nome do projeto, usado para nomear o repositório no ECR
variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "environment" {
  description = "O ambiente onde os recursos serão implantados (dev ou prod)"
  type        = string
}

variable "image_tag" {
  description = "Tag da imagem a ser usada no ECS"
  type        = string
  default     = "latest"
}