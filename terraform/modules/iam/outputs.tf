# Exporta o ARN da role ECS Task Execution, para uso no ECS
output "ecs_task_execution_role_arn" {
  description = "ARN da role IAM usada pelo ECS Task Execution"
  value       = aws_iam_role.ecs_task_execution_role.arn
}
