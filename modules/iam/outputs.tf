output "instance_profile_name" {
  value       = aws_iam_instance_profile.ec2.name
  description = "Passed to EC2 module so the web server can access S3"
}

output "role_arn" {
  value = aws_iam_role.ec2.arn
}
