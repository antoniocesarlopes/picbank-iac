
output "aws_region" {
  value       = var.aws_region
  description = "AWS region used for deployment"
}

output "cognito_user_pool_id" {
  value       = module.cognito.user_pool_id
  description = "AWS Cognito User Pool ID"
}

output "sqs_queue_url" {
  value       = module.sqs.sqs_queue_url
  description = "SQS Queue URL"
}

output "sqs_dlq_url" {
  value       = module.sqs.sqs_dlq_url
  description = "SQS Dead Letter Queue URL"
}

output "ses_sender_email" {
  value       = module.ses.ses_sender_email
  description = "SES sender email"
}

output "cognito_client_id" {
  value       = module.cognito.app_client_id
  description = "AWS Cognito App Client ID"
}

output "cognito_client_secret" {
  value       = module.cognito.app_client_secret
  description = "AWS Cognito App Client Secret"
  sensitive   = true
}

output "cognito_redirect_uri" {
  value       = "http://localhost:8080/api/login/oauth2/code/cognito"
  description = "Cognito OAuth2 Redirect URI"
}

output "cognito_issuer_uri" {
  value       = module.cognito.issuer_uri
  description = "AWS Cognito Issuer URI"
}

output "cognito_jwk_set_uri" {
  value       = module.cognito.jwk_set_uri
  description = "AWS Cognito JWK Set URI"
}
