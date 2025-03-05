output "public_subnet_ids" {
  description = "Lista de IDs das subnets públicas"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Lista de IDs das subnets privadas"
  value       = aws_subnet.private[*].id
}
