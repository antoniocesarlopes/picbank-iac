variable "project" {
  description = "Nome do projeto para padronização dos recursos"
  type        = string
}

variable "aws_region" {
  description = "Região da AWS onde os recursos serão provisionados"
  type        = string
}

variable "sqs_wait_time_seconds" {
  description = "Tempo de espera para long polling no SQS"
  type        = number
  default     = 10
}
