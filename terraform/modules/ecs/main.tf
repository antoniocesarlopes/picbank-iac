# ===========================
# CLUSTER DO ECS
# ===========================

# Criação do cluster ECS para execução dos containers
resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"  # Define um nome descritivo para o cluster

  tags = {
    Name        = "${var.project}-cluster"
    Environment = "dev"  # Identifica o ambiente
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
        containerPort = 8080,  # Porta usada no container
        hostPort = 8080  # Porta mapeada no host
      }]
      environment = [
        { name = "AWS_REGION", value = var.aws_region }  # Define variáveis de ambiente
      ]
      logConfiguration = {  # Configuração de logs no CloudWatch
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.project}-auth-service"  # Nome do grupo de logs
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

# Criação do serviço ECS para rodar a Task Definition acima
resource "aws_ecs_service" "auth_service" {
  name            = "auth-service"  # Nome do serviço
  cluster         = aws_ecs_cluster.main.id  # Associa ao cluster ECS criado
  task_definition = aws_ecs_task_definition.auth_service.arn  # Define a Task Definition usada
  desired_count   = 1  # Número de réplicas do container
  launch_type     = "FARGATE"  # Define o tipo de execução como Fargate

  # Configuração de rede para Fargate
  network_configuration {
    subnets          = var.subnet_ids  # Lista de subnets onde o serviço será executado
    assign_public_ip = true  # Garante que o serviço tenha um IP público para comunicação
  }

  tags = {
    Name        = "auth-service"
    Environment = var.environment  # Define o ambiente
  }
}
