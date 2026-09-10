variable "environment" {
  type = string
}

variable "s3_bucket_arn" {
  type        = string
  description = "ARN of the S3 app files bucket — scopes EC2 access to this bucket only"
}
