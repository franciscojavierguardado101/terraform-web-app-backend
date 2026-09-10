variable "environment" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "Private subnet IDs for the RDS subnet group"
}

variable "ec2_security_group_id" {
  type        = string
  description = "Security group ID of the EC2 instance — RDS only accepts connections from here"
}

variable "instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}
