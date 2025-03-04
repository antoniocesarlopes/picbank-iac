# Saídas globais

output "vpc_id" {
  description = "ID da VPC criada"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Lista de subnets públicas"
  value       = module.vpc.subnet_ids
}
