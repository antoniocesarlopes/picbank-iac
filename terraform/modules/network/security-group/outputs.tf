output "ecs_security_group_id" {
  description = "ID do Security Group do ECS"
  value       = aws_security_group.ecs.id
}
