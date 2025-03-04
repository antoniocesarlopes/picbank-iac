output "ses_sender_email" {
  description = "Endereço de e-mail autorizado para envio via SES"
  value       = aws_ses_email_identity.sender_email.email
}