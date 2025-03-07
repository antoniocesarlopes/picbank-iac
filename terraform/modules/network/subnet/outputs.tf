output "public_subnet_id" {
  description = "Lista de IDs das subnets públicas"
  value       = aws_subnet.public.id
}

