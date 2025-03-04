output "user_pool_id" {
  description = "ID do User Pool Cognito"
  value       = aws_cognito_user_pool.picbank_user_pool.id
}

output "app_client_id" {
  description = "ID do App Client Cognito"
  value       = aws_cognito_user_pool_client.picbank_client.id
}

output "issuer_uri" {
  description = "Issuer URI do Cognito"
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.picbank_user_pool.id}"
}

output "jwk_set_uri" {
  description = "JWK Set URI para autenticação"
  value       = "https://cognito-idp.${var.aws_region}.amazonaws.com/${aws_cognito_user_pool.picbank_user_pool.id}/.well-known/jwks.json"
}
