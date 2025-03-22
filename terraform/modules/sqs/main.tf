# ========================================================
# Módulo Terraform para criar filas SQS e configurar o SES
# ========================================================

# 🎯 Criando a fila SQS principal para solicitações de criação de usuário
resource "aws_sqs_queue" "user_data_request" {
  name                       = "user-data-request-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 0
  redrive_policy             = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.user_data_request_dlq.arn
    maxReceiveCount     = 5
  })
}

# 🎯 Criando a Dead Letter Queue (DLQ) para mensagens não processadas da fila user-data-request
resource "aws_sqs_queue" "user_data_request_dlq" {
  name                      = "user-data-request-dlq"
  message_retention_seconds = 1209600
}

# 🎯 Criando a fila SQS para atribuição de grupo de usuários no Cognito
resource "aws_sqs_queue" "user_group_assignment" {
  name                       = "user-group-assignment-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 0
  redrive_policy             = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.user_group_assignment_dlq.arn
    maxReceiveCount     = 5
  })
}

# 🎯 Criando a Dead Letter Queue (DLQ) para mensagens não processadas da fila user-group-assignment
resource "aws_sqs_queue" "user_group_assignment_dlq" {
  name                      = "user-group-assignment-dlq"
  message_retention_seconds = 1209600
}

# 🎯 Criando a fila SQS para resposta de dados do usuário
resource "aws_sqs_queue" "user_data_response" {
  name                       = "user-data-response-queue"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 86400
  receive_wait_time_seconds  = 0
  redrive_policy             = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.user_data_response_dlq.arn
    maxReceiveCount     = 5
  })
}

# 🎯 Criando a Dead Letter Queue (DLQ) para mensagens não processadas da fila user-data-response
resource "aws_sqs_queue" "user_data_response_dlq" {
  name                      = "user-data-response-dlq"
  message_retention_seconds = 1209600
}

# 🎯 Criando a política de permissões para permitir que o serviço envie mensagens para as filas
resource "aws_sqs_queue_policy" "user_data_request_policy" {
  queue_url = aws_sqs_queue.user_data_request.id
  policy    = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sqs:SendMessage",
      Resource  = aws_sqs_queue.user_data_request.arn
    }]
  })
}

resource "aws_sqs_queue_policy" "user_group_assignment_policy" {
  queue_url = aws_sqs_queue.user_group_assignment.id
  policy    = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sqs:SendMessage",
      Resource  = aws_sqs_queue.user_group_assignment.arn
    }]
  })
}

resource "aws_sqs_queue_policy" "user_data_response_policy" {
  queue_url = aws_sqs_queue.user_data_response.id
  policy    = jsonencode({
    Version   = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = { Service = "ecs-tasks.amazonaws.com" },
      Action    = "sqs:SendMessage",
      Resource  = aws_sqs_queue.user_data_response.arn
    }]
  })
}