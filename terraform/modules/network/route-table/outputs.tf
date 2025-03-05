output "public_route_table_id" {
  description = "ID da tabela de rotas pública"
  value       = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "ID da tabela de rotas privada"
  value       = aws_route_table.private.id
}
