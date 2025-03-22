# ========================
# CONFIGURAÇÃO DO AMBIENTE DEV
# ========================

# Módulo de VPC (Virtual Private Cloud)
module "vpc" {
  source      = "../../modules/network/vpc"
  project     = var.project
  environment = var.environment
  cidr_block  = var.cidr_block
}

# Módulo das Subnets (Públicas e Privadas)
module "subnet" {
  source          = "../../modules/network/subnet"
  project         = var.project
  environment     = var.environment
  vpc_id          = module.vpc.vpc_id
  public_subnets  = var.public_subnets
}

# Módulo do Internet Gateway (IGW)
module "internet_gateway" {
  source      = "../../modules/network/internet-gateway"
  project     = var.project
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
}

# Módulo de Route Table (Tabelas de Rotas)
module "route_table" {
  source              = "../../modules/network/route-table"
  project             = var.project
  environment         = var.environment
  vpc_id              = module.vpc.vpc_id
  internet_gateway_id = module.internet_gateway.internet_gateway_id
  public_subnet_ids   = [module.subnet.public_subnet1_id, module.subnet.public_subnet2_id]
}

# Módulo de Security Groups
module "security_groups" {
  source       = "../../modules/network/security-group"
  project      = var.project
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  service_port = var.service_port
}

# Módulo de IAM
module "iam" {
  source  = "../../modules/iam"
  project = var.project
  environment  = var.environment
}

# Módulo de ECR
module "ecr" {
  source  = "../../modules/ecr"
  project = var.project  
  environment  = var.environment
}

# Módulo do Cognito
module "cognito" {
  source       = "../../modules/cognito"
  project      = var.project
  aws_region   = var.aws_region
  redirect_uri = "http://localhost:8080/api/login/oauth2/code/cognito"
}

# Módulo do SES (Simple Email Service)
module "ses" {
  source            = "../../modules/ses"
  project           = var.project
  aws_region        = var.aws_region
  ses_sender_email  = var.ses_sender_email
}

# Módulo do SQS (Simple Queue Service)
module "sqs" {
  source                = "../../modules/sqs"
  project               = var.project
  aws_region            = var.aws_region
  sqs_wait_time_seconds = var.sqs_wait_time_seconds
}

# Módulo do ECS
module "ecs" {
  source             = "../../modules/ecs"
  project            = var.project
  image_url          = module.ecr.repository_url
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  subnet_ids         = [module.subnet.public_subnet1_id, module.subnet.public_subnet2_id]
  aws_region         = var.aws_region
  environment        = var.environment
  security_group_id  = module.security_groups.ecs_security_group_id

  # Cognito
  cognito_user_pool_id  = module.cognito.user_pool_id
  cognito_client_id     = module.cognito.app_client_id
  cognito_client_secret = module.cognito.app_client_secret
  cognito_issuer_uri    = module.cognito.issuer_uri
  cognito_jwk_set_uri   = module.cognito.jwk_set_uri
  cognito_user_pool_arn = module.cognito.cognito_user_pool_arn

  # 🎯 Configuração das filas SQS
  sqs_queue_url_user_data_request      = module.sqs.sqs_queue_url_user_data_request
  sqs_queue_url_user_group_assignment  = module.sqs.sqs_queue_url_user_group_assignment
  sqs_queue_url_user_data_response     = module.sqs.sqs_queue_url_user_data_response

  sqs_dlq_url_user_data_request        = module.sqs.sqs_dlq_url_user_data_request
  sqs_dlq_url_user_group_assignment    = module.sqs.sqs_dlq_url_user_group_assignment
  sqs_dlq_url_user_data_response       = module.sqs.sqs_dlq_url_user_data_response

  # SES
  ses_sender_email = module.ses.ses_sender_email

  # Variáveis sensíveis
  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key
}
