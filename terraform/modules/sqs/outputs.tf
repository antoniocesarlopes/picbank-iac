output "sqs_queue_url" {
  description = "URL da fila SQS principal"
  value       = aws_sqs_queue.auth_queue.id
}

output "sqs_dlq_url" {
  description = "URL da Dead Letter Queue (DLQ)"
  value       = aws_sqs_queue.auth_dlq.id
}