# =========================================
# Módulo Terraform para configuração do AWS Cognito
# =========================================

# 🚀 Criação do User Pool no Cognito
resource "aws_cognito_user_pool" "picbank_user_pool" {
  name = "${var.project}-user-pool"

  # Definição dos atributos obrigatórios para sign-up
  schema {
    name                     = "name"
    attribute_data_type      = "String"
    mutable                  = true
    required                 = true
  }

  schema {
    name                     = "email"
    attribute_data_type      = "String"
    mutable                  = true
    required                 = true
  }

  schema {
    name                     = "document"
    attribute_data_type      = "String"
    mutable                  = true
    required                 = true
    string_attribute_constraints {
      min_length = 11
      max_length = 14
    }
  }

  # Configuração da política de senha
  password_policy {
    minimum_length                   = 8
    require_uppercase                = true
    require_lowercase                = true
    require_numbers                   = true
    require_symbols                   = true
  }

  # Ativação da recuperação de conta por e-mail
  auto_verified_attributes = ["email"]
}

# 🎭 Criação dos Grupos de Usuários
resource "aws_cognito_user_group" "merchant_group" {
  name         = "Merchant"
  user_pool_id = aws_cognito_user_pool.picbank_user_pool.id
  description  = "Grupo para lojistas"
}

resource "aws_cognito_user_group" "standard_group" {
  name         = "Standard"
  user_pool_id = aws_cognito_user_pool.picbank_user_pool.id
  description  = "Grupo para usuários comuns"
}

# 📲 Configuração do App Client
resource "aws_cognito_user_pool_client" "picbank_client" {
  name                                 = "${var.project}-app-client"
  user_pool_id                         = aws_cognito_user_pool.picbank_user_pool.id
  generate_secret                      = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code"]
  allowed_oauth_scopes                 = ["openid", "profile", "email"]
  callback_urls                         = [var.redirect_uri]
  supported_identity_providers         = ["COGNITO"]
}

# 🔗 Configuração da URL do Provedor Cognito
resource "aws_cognito_user_pool_domain" "picbank_domain" {
  domain       = "${var.project}-auth"
  user_pool_id = aws_cognito_user_pool.picbank_user_pool.id
}
