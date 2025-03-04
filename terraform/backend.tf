# Armazena o estado do Terraform no S3 para evitar que várias pessoas sobrescrevam configurações.
# Usa o DynamoDB para evitar concorrência e garantir que apenas uma pessoa aplique mudanças por vez.

terraform {
  backend "s3" {
    bucket         = "picbank-terraform-state"   # Nome do bucket S3 onde o estado será armazenado
    key            = "auth-service/terraform.tfstate"  # Caminho do arquivo dentro do bucket
    region         = "us-east-1"  # Região da AWS onde o S3 está
    encrypt        = true  # Ativa criptografia no S3 para segurança
    dynamodb_table = "picbank-terraform-lock"  # Nome da tabela DynamoDB usada para lock (evita concorrência)
  }
}
