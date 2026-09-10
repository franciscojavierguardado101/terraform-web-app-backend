variable "environment" {
  type = string
}

variable "vpc_id" {
  type        = string
  description = "VPC where the EC2 instance will be deployed"
}

variable "public_subnet_id" {
  type        = string
  description = "Public subnet ID where the web server will run"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"  # free tier eligible
}

variable "ssh_allowed_cidr" {
  type        = list(string)
  description = "CIDR blocks allowed to SSH — restrict to your IP in prod"
  default     = ["0.0.0.0/0"]
}

variable "instance_profile_name" {
  type        = string
  description = "IAM instance profile name — gives EC2 permission to access S3"
}
