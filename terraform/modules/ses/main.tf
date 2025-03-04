# ========================================================
# Configuração do AWS SES para envio de e-mails
# ========================================================

# 🎯 Habilitando o SES para envio de e-mails
resource "aws_ses_email_identity" "sender_email" {
  email = var.ses_sender_email
}

# 🎯 Criando uma política para permitir o envio de e-mails via SES
resource "aws_iam_policy" "ses_send_email_policy" {
  name        = "${var.project}-ses-send-email-policy"
  description = "Permite envio de emails via SES"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ses:SendEmail"
        Resource = "*"
      }
    ]
  })
}
