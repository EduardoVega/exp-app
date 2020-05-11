# Providers
provider "aws" {
  version = "~> 2.0"
  region  = var.aws-region
}

terraform {
  backend "s3" {}
}

# Resources
resource "aws_db_subnet_group" "tomcat" {
  name       = var.project-name
  subnet_ids = var.rds-subnet-ids
}

resource "aws_db_instance" "tomcat" {
  allocated_storage    = 20
  max_allocated_storage = 40
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t2.micro"
  name                 = var.project-name
  identifier           = var.project-name
  username             = var.username
  password             = var.password
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.tomcat.id
  vpc_security_group_ids  = [ var.rds-security-group-id ]
  skip_final_snapshot = true
}