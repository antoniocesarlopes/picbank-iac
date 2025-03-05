# Nome do projeto, usado para nomear o repositório no ECR
variable "project" {
  description = "Nome do projeto"
  type        = string
}
variable "image_tag" {
  description = "Tag da imagem a ser usada no ECS"
  type        = string
  default     = "latest"
}