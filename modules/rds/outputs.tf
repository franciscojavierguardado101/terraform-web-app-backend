output "db_endpoint" {
  value       = aws_db_instance.postgres.endpoint
  description = "RDS connection endpoint — used by the app to connect to the database"
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}

output "db_port" {
  value = aws_db_instance.postgres.port
}
