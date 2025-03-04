variable "cidr_block" {
  description = "CIDR block for the VPC"
}

variable "public_subnets" {
  description = "List of public subnets"
  type        = list(string)
}

variable "project" {
  description = "The project name"
}
