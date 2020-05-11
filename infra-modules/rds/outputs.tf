output "rds-address" {
  value       =  aws_db_instance.tomcat.address
  description = "RDS hostname"
}

output "rds-name" {
  value       =  aws_db_instance.tomcat.name
  description = "RDS name"
}

output "rds-endpoint" {
  value       =  aws_db_instance.tomcat.endpoint
  description = "RDS endpoint"
}