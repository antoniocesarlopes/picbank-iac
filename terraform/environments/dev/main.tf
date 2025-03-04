# Configuração do ambiente DEV

module "vpc" {
  source         = "../../modules/vpc"
  project        = var.project
  cidr_block     = var.cidr_block
  public_subnets = var.public_subnets
}

module "iam" {
  source  = "../../modules/iam"
  project = var.project
}

module "ecr" {
  source  = "../../modules/ecr"
  project = var.project  
}

module "ecs" {
  source             = "../../modules/ecs"
  project            = var.project
  image_url          = var.ecr.repository_url
  execution_role_arn = var.iam.ecs_task_execution_role_arn
  subnet_ids         = var.vpc.subnet_ids
  aws_region         = var.aws_region
  environment        = var.environment
}

module "cognito" {
  source       = "../../modules/cognito"
  project      = var.project
  aws_region   = var.aws_region
  redirect_uri = "http://localhost:8080/api/login/oauth2/code/cognito"
}

module "s3" {
  source             = "../../modules/s3"
  bucket_terraform_state = var.bucket_terraform_state
}

module "dinamodb" {
  source             = "../../modules/dinamodb"
  dynamoDB_terraform_locks = var.dynamoDB_terraform_locks
}

module "ses" {
  source            = "../../modules/ses"
  project           = var.project
  aws_region        = var.aws_region
  ses_sender_email  = var.ses_sender_email
}

module "sqs" {
  source            = "../../modules/sqs"
  project           = var.project
  aws_region        = var.aws_region
  sqs_wait_time_seconds = var.sqs_wait_time_seconds
}