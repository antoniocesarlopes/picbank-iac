variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "project" {
  description = "The project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment (dev, prod, etc.)"
  type        = string
}
