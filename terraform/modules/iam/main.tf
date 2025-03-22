# ==========================================
# IAM: ROLE PARA EXECUÇÃO DE TAREFAS DO ECS
# ==========================================

# Cria uma role IAM que será assumida pelo ECS para execução de tarefas
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "${var.project}-ecs-task-execution-role"  # Define um nome descritivo para a role

  # Define a política que permite ao ECS assumir essa role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"  # Permite que essa role seja assumida
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }  # Especifica que somente ECS Tasks podem assumir essa role
    }]
  })

  tags = {
    Name        = "${var.project}-ecs-task-execution-role"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_iam_policy" "ecr_access_policy" {
  name        = "${var.project}-ecs-ecr-access"
  description = "Permissões para o ECS acessar o ECR"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}


# ================================
# POLÍTICAS DE PERMISSÕES DA ROLE
# ================================

# Anexa a política padrão do ECS para execução de tarefas
resource "aws_iam_role_policy_attachment" "ecs_task_execution" {
  role       = aws_iam_role.ecs_task_execution_role.name  # Associa a role criada acima
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"  # Permissões essenciais para execução de tarefas do ECS
}

# Permite que a role tenha acesso completo aos logs do CloudWatch
resource "aws_iam_role_policy_attachment" "ecs_task_cloudwatch_logs" {
  role       = aws_iam_role.ecs_task_execution_role.name 
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"  # Permissão para escrita e leitura de logs no CloudWatch
}

# Permitir envio de emails via SES
resource "aws_iam_role_policy_attachment" "ecs_task_ses_access" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
}

# Permitir envio e recebimento de mensagens via SQS
resource "aws_iam_role_policy_attachment" "ecs_task_sqs_access" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

# Permitir autenticação e autorização via Cognito
resource "aws_iam_role_policy_attachment" "ecs_task_cognito_access" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonCognitoPowerUser"
}

# Permite obter imagens do repositório ECR.
resource "aws_iam_role_policy_attachment" "ecs_task_ecr_access" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecr_access_policy.arn
}