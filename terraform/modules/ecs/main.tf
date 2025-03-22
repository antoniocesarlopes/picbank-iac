# ===========================
# CLUSTER DO ECS
# ===========================

# Criação do cluster ECS onde as tarefas (services) serão executadas
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"  # Nome do cluster, baseado no nome do projeto

  # Definição das tags associadas ao cluster
  tags = {
    Name        = "${var.project}-cluster"  # Nome do cluster
    Environment = var.environment          # Ambiente (dev, prod, etc.)
    ManagedBy   = "Terraform"              # Indica que o recurso é gerenciado pelo Terraform
  }
}

# ===========================
# CLOUDWATCH LOG GROUP PARA ECS
# ===========================

# Criação do grupo de logs do CloudWatch para armazenar logs das tarefas ECS
resource "aws_cloudwatch_log_group" "ecs_logs" {
  name              = "/ecs/${var.project}-auth-service"  # Nome do grupo de logs
  retention_in_days = 1  # Retenção dos logs por 1 dia

  # Definição das tags associadas ao grupo de logs
  tags = {
    Name        = "${var.project}-auth-service-logs"  # Nome do grupo de logs
    Environment = var.environment                    # Ambiente (dev, prod, etc.)
    ManagedBy   = "Terraform"                        # Indica que o recurso é gerenciado pelo Terraform
  }
}

# ===========================
# IAM ROLE PARA ECS TASK EXECUTION
# ===========================

# Criação de uma role IAM para execução das tarefas ECS (Fargate)
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-ecs-task-execution-role"  # Nome da role

  # Política que permite que a tarefa ECS assuma essa role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }  # Permite que o ECS execute tarefas
      Action = "sts:AssumeRole"
    }]
  })

  # Definição das tags associadas à role IAM
  tags = {
    Name        = "${var.project}-ecs-task-execution-role"  # Nome da role
    Environment = var.environment                          # Ambiente (dev, prod, etc.)
    ManagedBy   = "Terraform"                              # Indica que o recurso é gerenciado pelo Terraform
  }
}

# ===========================
# PERMISSÕES PARA O ECS TASK ROLE
# ===========================

# Criação de uma policy IAM com permissões necessárias para a tarefa ECS acessar outros recursos
resource "aws_iam_policy" "ecs_task_permissions" {
  name        = "${var.project}-ecs-task-permissions"  # Nome da policy
  description = "Permissões para ECS acessar Cognito, SQS e SES"  # Descrição da policy

  # Definição das permissões para a tarefa ECS
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = ["cognito-idp:AdminGetUser", "cognito-idp:ListUsers"]  # Permissões para acessar o Cognito
        Resource = var.cognito_user_pool_arn
      },
      {
        Effect = "Allow"
        Action = ["sqs:SendMessage", "sqs:ReceiveMessage", "sqs:DeleteMessage", "sqs:GetQueueAttributes"]  # Permissões para interagir com SQS
        Resource = [
          var.sqs_queue_url_user_data_request,
          var.sqs_queue_url_user_group_assignment,
          var.sqs_queue_url_user_data_response
        ]
      },
      {
        Effect = "Allow"
        Action = ["ses:SendEmail", "ses:SendRawEmail"]  # Permissões para enviar e-mails via SES
        Resource = "*"
      }
    ]
  })
}

# Anexar a policy ao IAM Role, permitindo que a role execute as ações da policy
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name  # Nome da role IAM
  policy_arn = aws_iam_policy.ecs_task_permissions.arn  # ARN da policy IAM
}

# ===========================
# TASK DEFINITION (AUTH-SERVICE)
# ===========================

# Criação da definição de tarefa ECS para o serviço 'auth-service'
resource "aws_ecs_task_definition" "auth_service" {
  family                   = "auth-service"  # Nome da família de tarefas
  requires_compatibilities = ["FARGATE"]  # Compatível com Fargate
  cpu                      = "256"  # Recursos de CPU alocados
  memory                   = "512"  # Recursos de memória alocados
  network_mode             = "awsvpc"  # Modo de rede (usando VPC)
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn  # ARN da role para execução da tarefa

  # Definição do container, incluindo a imagem e as variáveis de ambiente
  container_definitions = jsonencode([
    {
      name  = "auth-service"
      image = var.image_url  # URL da imagem do container
      portMappings = [{ containerPort = 8080, hostPort = 8080 }]  # Mapeamento de portas

      # Variáveis de ambiente do container
      environment = [
        { name = "AWS_REGION", value = var.aws_region },
        { name = "AWS_COGNITO_USER_POOL_ID", value = var.cognito_user_pool_id },
        { name = "AWS_COGNITO_CLIENT_ID", value = var.cognito_client_id },
        { name = "AWS_COGNITO_CLIENT_SECRET", value = var.cognito_client_secret },
        { name = "AWS_COGNITO_ISSUER_URI", value = var.cognito_issuer_uri },
        { name = "AWS_COGNITO_JWK_SET_URI", value = var.cognito_jwk_set_uri },
        { name = "AWS_SES_SENDER_EMAIL", value = var.ses_sender_email },
        { name = "AWS_SQS_QUEUE_URL_USER_DATA_REQUEST", value = var.sqs_queue_url_user_data_request },
        { name = "AWS_SQS_QUEUE_URL_USER_GROUP_ASSIGNMENT", value = var.sqs_queue_url_user_group_assignment },
        { name = "AWS_SQS_QUEUE_URL_USER_DATA_RESPONSE", value = var.sqs_queue_url_user_data_response },
        { name = "AWS_SQS_DLQ_URL_USER_DATA_REQUEST", value = var.sqs_dlq_url_user_data_request },
        { name = "AWS_SQS_DLQ_URL_USER_GROUP_ASSIGNMENT", value = var.sqs_dlq_url_user_group_assignment },
        { name = "AWS_SQS_DLQ_URL_USER_DATA_RESPONSE", value = var.sqs_dlq_url_user_data_response }
      ],

      # Configuração de logs para o container no CloudWatch
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_logs.name  # Grupo de logs do CloudWatch
          awslogs-region        = var.aws_region  # Região AWS
          awslogs-stream-prefix = "ecs"  # Prefixo dos streams de logs
        }
      }
    }
  ])
}

# ===========================
# SERVIÇO ECS (AUTH-SERVICE)
# ===========================

# Criação do serviço ECS para o 'auth-service', que irá executar a tarefa definida
resource "aws_ecs_service" "auth_service" {
  name            = "auth-service"  # Nome do serviço ECS
  cluster         = aws_ecs_cluster.main.id  # ID do cluster ECS
  task_definition = aws_ecs_task_definition.auth_service.arn  # ARN da definição da tarefa
  desired_count   = 1  # Número desejado de instâncias da tarefa
  launch_type     = "FARGATE"  # Tipo de lançamento (Fargate)

  # Configuração de rede para o serviço ECS
  network_configuration {
    subnets          = var.subnet_ids  # IDs das sub-redes onde o serviço irá rodar
    assign_public_ip = true  # Atribui IP público para o serviço
    security_groups  = [var.security_group_id]  # ID do security group associado
  }

  # Definição das tags associadas ao serviço ECS
  tags = {
    Name        = "auth-service"  # Nome do serviço
    Environment = var.environment  # Ambiente (dev, prod, etc.)
    ManagedBy   = "Terraform"  # Indica que o recurso é gerenciado pelo Terraform
  }
}
