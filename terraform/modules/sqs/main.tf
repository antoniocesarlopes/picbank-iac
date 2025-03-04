# ========================================================
# Módulo Terraform para criar filas SQS e configurar o SES
# ========================================================

# 🎯 Criando a fila SQS principal
resource "aws_sqs_queue" "auth_queue" {
  name                      = "${var.project}-auth-queue"
  message_retention_seconds = 86400
  visibility_timeout_seconds = 30
  receive_wait_time_seconds = var.sqs_wait_time_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.auth_dlq.arn
    maxReceiveCount     = 5
  })
}

# 🎯 Criando a Dead Letter Queue (DLQ) para mensagens não processadas
resource "aws_sqs_queue" "auth_dlq" {
  name                      = "${var.project}-auth-queue-dlq"
  message_retention_seconds = 86400
}

# 🎯 Criando a política de permissões para permitir que o serviço envie mensagens
resource "aws_sqs_queue_policy" "auth_queue_policy" {
  queue_url = aws_sqs_queue.auth_queue.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = "*"
        Action    = "sqs:SendMessage"
        Resource  = aws_sqs_queue.auth_queue.arn
      }
    ]
  })
}