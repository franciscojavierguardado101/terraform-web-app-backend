output "bucket_id" {
  value = aws_s3_bucket.app_files.id
}

output "bucket_arn" {
  value = aws_s3_bucket.app_files.arn
}
