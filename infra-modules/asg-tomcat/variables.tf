variable "vpc-id" {
    type    = string
    description = "VPC Id"
}

variable "aws-region" {
    type    = string
    description = "AWS Region"
}

variable "ec2-instance-type" {
    type    = string
    description = "EC2 Instance Type"
}

variable "ami-id" {
    type    = string
    description = "Tomcat AMI ID"
}

variable "project-name" {
  type    = string
  description = "VPC name"
}

variable "key-name" {
  type    = string
  description = "SSH key name"
}

variable "load-balancer-security-group-id" {
  type    = string
  description = "Security Group id for the Load Balancers"
}

variable "tomcat-security-group-id" {
  type    = string
  description = "Security Group id for the Tomcat VMs"
}

variable "load-balancer-subnet-ids" {
  type    = list(string)
  description = "Subnets ids for the Load Balancer"
}

variable "tomcat-subnet-ids" {
  type    = list(string)
  description = "Subnets ids for the Tomcat VMs"
}