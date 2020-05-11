variable "aws-region" {
  default = "us-east-1"
  type    = string
  description = "AWS region"
}

variable "rds-security-group-id" {
  type    = string
  description = "Security Group id for the RDS instance"
}

variable "rds-subnet-ids" {
  type    = list(string)
  description = "Subnets ids for the RDS instance"
}

variable "project-name" {
  type    = string
  description = "Project Name"
}

variable "username" {
  type    = string
  description = "RDS username"
}

variable "password" {
  type    = string
  description = "RDS password"
}