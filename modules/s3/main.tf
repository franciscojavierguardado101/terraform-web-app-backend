# S3 bucket for app file storage — user uploads, assets, logs
resource "aws_s3_bucket" "app_files" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

# Block all public access — files are served through the app, not directly from S3
resource "aws_s3_bucket_public_access_block" "app_files" {
  bucket                  = aws_s3_bucket.app_files.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Encrypt all files at rest
resource "aws_s3_bucket_server_side_encryption_configuration" "app_files" {
  bucket = aws_s3_bucket.app_files.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Versioning — keeps previous versions of files, useful for recovery
resource "aws_s3_bucket_versioning" "app_files" {
  bucket = aws_s3_bucket.app_files.id
  versioning_configuration {
    status = "Enabled"
  }
}
