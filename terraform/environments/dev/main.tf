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
  private_subnets = var.private_subnets
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
  public_subnet_ids   = module.subnet.public_subnet_ids
  private_subnet_ids  = module.subnet.private_subnet_ids
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
}

# Módulo de ECR
module "ecr" {
  source  = "../../modules/ecr"
  project = var.project  
}

# Módulo de ECS
module "ecs" {
  source             = "../../modules/ecs"
  project            = var.project
  image_url          = module.ecr.repository_url
  execution_role_arn = var.execution_role_arn
  subnet_ids         = module.subnet.public_subnet_ids
  aws_region         = var.aws_region
  environment        = var.environment
  security_group_ids = [module.security_groups.ecs_security_group_id]
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
