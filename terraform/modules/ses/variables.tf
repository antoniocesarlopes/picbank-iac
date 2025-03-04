variable "project" {
  description = "Nome do projeto para padronização dos recursos"
  type        = string
}

variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados"
  type        = string
}

variable "ses_sender_email" {
  description = "Endereço de e-mail autorizado para envio via SES"
  type        = string
}
