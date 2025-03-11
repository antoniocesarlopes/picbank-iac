# ===========================
# CLUSTER DO ECS
# ===========================

# Criação do cluster ECS para execução dos containers
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"  # Define um nome descritivo para o cluster

  tags = {
    Name        = "${var.project}-cluster"
    Environment = var.environment  # Define o ambiente
  }
}

# ===========================
# CLOUDWATCH LOG GROUP PARA ECS
# ===========================

resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project}-auth-service"
  retention_in_days = 1  # Mantém os logs por 1 dia

  tags = {
    Name        = "${var.project}-auth-service-logs"
    Environment = var.environment
  }
}

# ===========================
# TASK DEFINITION (AUTH-SERVICE)
# ===========================

# Define a Task Definition que será usada pelo serviço ECS
resource "aws_ecs_task_definition" "auth_service" {
  family                   = "auth-service"  # Nome da família da task
  requires_compatibilities = ["FARGATE"]  # Define que a task rodará no modo Fargate
  cpu                      = "256"  # Define a quantidade de CPU alocada
  memory                   = "512"  # Define a quantidade de memória RAM alocada
  network_mode             = "awsvpc"  # Usa o modo de rede recomendado para Fargate
  execution_role_arn       = var.execution_role_arn  # Role IAM usada para execução

  # Configuração do container principal
  container_definitions = jsonencode([
    {
      name  = "auth-service"  # Nome do container
      image = var.image_url  # URL da imagem no ECR
      portMappings = [{ 
        containerPort = 8080, # Porta usada no container
        hostPort      = 8080  # Porta mapeada no host
      }]
      environment = [
      { name = "AWS_REGION", value = "us-east-1" },
      { name = "AWS_COGNITO_USER_POOL_ID", value = var.cognito_user_pool_id },
      { name = "AWS_COGNITO_CLIENT_ID", value = var.cognito_client_id },
      { name = "AWS_COGNITO_CLIENT_SECRET", value = var.cognito_client_secret },
      { name = "AWS_COGNITO_ISSUER_URI", value = var.cognito_issuer_uri },
      { name = "AWS_COGNITO_JWK_SET_URI", value = var.cognito_jwk_set_uri },
      { name = "AWS_SQS_QUEUE_URL", value = var.sqs_queue_url },
      { name = "AWS_SQS_DLQ_URL", value = var.sqs_dlq_url },
      { name = "AWS_SQS_FIXED_RATE_MS", value = "60000" },
      { name = "AWS_SQS_MAX_MESSAGES", value = "5" },
      { name = "AWS_SQS_WAIT_TIME_SECONDS", value = "10" },
      { name = "AWS_SES_SENDER_EMAIL", value = var.ses_sender_email },
      { name = "AWS_ACCESS_KEY_ID", value = var.aws_access_key_id },
      { name = "AWS_SECRET_ACCESS_KEY", value = var.aws_secret_access_key }
      ]
      
      logConfiguration = {  # Configuração de logs no CloudWatch
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name  # Nome do grupo de logs
          awslogs-region        = var.aws_region  # Região da AWS
          awslogs-stream-prefix = "ecs"  # Prefixo para os logs no CloudWatch
        }
      }
    }
  ])
}

# ===========================
# SERVIÇO ECS (AUTH-SERVICE)
# ===========================

resource "aws_ecs_service" "auth_service" {
  name            = "auth-service"  # Nome do serviço
  cluster         = aws_ecs_cluster.main.id  # Associa ao cluster ECS criado
  task_definition = aws_ecs_task_definition.auth_service.arn  # Define a Task Definition usada
  desired_count   = 1  # Número de réplicas do container
  launch_type     = "FARGATE"  # Define o tipo de execução como Fargate

  # Configuração de rede para Fargate
  network_configuration {
    subnets          = [var.subnet_id]  # subnet onde o serviço será executado
    assign_public_ip = true  # Garante que o serviço tenha um IP público para comunicação
    security_groups  = [var.security_group_id]  # Associar os security groups aqui
  }

  tags = {
    Name        = "auth-service"
    Environment = var.environment  # Define o ambiente
  }
}

