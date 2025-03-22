output "AWS_REGION" {
  value       = var.aws_region
  description = "AWS region used for deployment"
}

output "COGNITO_USER_POOL_ID" {
  value       = module.cognito.user_pool_id
  description = "AWS Cognito User Pool ID"
}

output "AWS_SQS_QUEUE_URL_USER_DATA_REQUEST" {
  value       = module.sqs.sqs_queue_url_user_data_request
  description = "URL da fila SQS para requisições de criação de usuário"
}

output "AWS_SQS_QUEUE_URL_USER_GROUP_ASSIGNMENT" {
  value       = module.sqs.sqs_queue_url_user_group_assignment
  description = "URL da fila SQS para atribuição de grupo de usuário"
}

output "AWS_SQS_QUEUE_URL_USER_DATA_RESPONSE" {
  value       = module.sqs.sqs_queue_url_user_data_response
  description = "URL da fila SQS para resposta com dados do usuário"
}

output "AWS_SQS_DLQ_URL_USER_DATA_REQUEST" {
  value       = module.sqs.sqs_dlq_url_user_data_request
  description = "URL da DLQ para requisições de criação de usuário não processadas"
}

output "AWS_SQS_DLQ_URL_USER_GROUP_ASSIGNMENT" {
  value       = module.sqs.sqs_dlq_url_user_group_assignment
  description = "URL da DLQ para atribuição de grupo de usuário não processadas"
}

output "AWS_SQS_DLQ_URL_USER_DATA_RESPONSE" {
  value       = module.sqs.sqs_dlq_url_user_data_response
  description = "URL da DLQ para resposta com dados do usuário não processadas"
}

output "SES_SENDER_EMAIL" {
  value       = module.ses.ses_sender_email
  description = "SES sender email"
}

output "COGNITO_CLIENT_ID" {
  value       = module.cognito.app_client_id
  description = "AWS Cognito App Client ID"
}

output "COGNITO_CLIENT_SECRET" {
  value       = module.cognito.app_client_secret
  description = "AWS Cognito App Client Secret"
  sensitive   = true
}

output "COGNITO_REDIRECT_URI" {
  value       = "http://localhost:8080/api/login/oauth2/code/cognito"
  description = "Cognito OAuth2 Redirect URI"
}

output "COGNITO_ISSUER_URI" {
  value       = module.cognito.issuer_uri
  description = "AWS Cognito Issuer URI"
}

output "COGNITO_JWK_SET_URI" {
  value       = module.cognito.jwk_set_uri
  description = "AWS Cognito JWK Set URI"
}

output "REPOSITORY_URL" {
  value       = module.ecr.repository_url
  description = "Repository URL for ECR"
}

output "ECS_CLUSTER_NAME" {
  description = "Cluster ECS name"
  value       = module.ecs.ecs_cluster_name
}

output "ECS_SERVICE_NAME" {
  description = "ECS service name"
  value       = module.ecs.ecs_service_name
}

# ARN do IAM Role de execução do ECS
output "EXECUTION_ROLE_ARN" {
  description = "ARN da IAM Role usada pelo ECS para execução de tarefas"
  value       = module.ecs.execution_role_arn
}
