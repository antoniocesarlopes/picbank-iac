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
    Environment = "dev"  # Define o ambiente para organização
  }
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
  role       = aws_iam_role.ecs_task_execution_role.name  # Associa à mesma role
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess"  # Permissão para escrita e leitura de logs no CloudWatch
}
