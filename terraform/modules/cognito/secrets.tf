output "app_client_secret" {
  description = "Client Secret do App Client Cognito"
  value       = aws_cognito_user_pool_client.picbank_client.client_secret
  sensitive   = true
}
