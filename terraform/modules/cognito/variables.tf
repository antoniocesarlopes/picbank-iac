# Nome do projeto
variable "project" {
  description = "Nome do projeto"
  type        = string
}

# Região da AWS
variable "aws_region" {
  description = "Região AWS"
  type        = string
}

# URI de redirecionamento do OAuth2
variable "redirect_uri" {
  description = "URI de redirecionamento para o OAuth2 do Cognito"
  type        = string
}
