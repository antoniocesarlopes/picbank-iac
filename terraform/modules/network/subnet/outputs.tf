output "public_subnet1_id" {
  description = "ID da subnet pública 1"
  value       = aws_subnet.public_1.id
}

output "public_subnet2_id" {
  description = "ID da subnet pública 2"
  value       = aws_subnet.public_2.id
}