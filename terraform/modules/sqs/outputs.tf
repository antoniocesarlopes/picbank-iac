output "sqs_queue_url_user_data_request" {
  value = aws_sqs_queue.user_data_request.id
}

output "sqs_dlq_url_user_data_request" {
  value = aws_sqs_queue.user_data_request_dlq.id
}

output "sqs_queue_url_user_group_assignment" {
  value = aws_sqs_queue.user_group_assignment.id
}

output "sqs_dlq_url_user_group_assignment" {
  value = aws_sqs_queue.user_group_assignment_dlq.id
}

output "sqs_queue_url_user_data_response" {
  value = aws_sqs_queue.user_data_response.id
}

output "sqs_dlq_url_user_data_response" {
  value = aws_sqs_queue.user_data_response_dlq.id
}
