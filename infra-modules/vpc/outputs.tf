output "vpc-id" {
  value       =  aws_vpc.main.id
  description = "VPC ID"
}

output "public-subnet-ids" {
  value       =  aws_subnet.public.*.id
  description = "Public subnet IDs"
}

output "private-subnet-ids" {
  value       =  aws_subnet.private.*.id
  description = "Private subnet IDs"
}

output "load-balancer-security-group-id" {
  value       =  aws_security_group.lb.id
  description = "Load Balancer security group ID"
}

output "tomcat-security-group-id" {
  value       =  aws_security_group.tomcat.id
  description = "Tomcat security group id"
}

output "rds-security-group-id" {
  value       =  aws_security_group.rds.id
  description = "RDS security group id"
}