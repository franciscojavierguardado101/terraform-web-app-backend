variable "environment" {
  type = string
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR for the public subnet where EC2 lives"
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr_1" {
  type        = string
  description = "CIDR for private subnet 1 where RDS lives"
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidr_2" {
  type        = string
  description = "CIDR for private subnet 2 — required by RDS subnet group"
  default     = "10.0.3.0/24"
}
