terraform {
  source = "git@github.com:EduardoVega/exp-app.git//infra-modules/asg-tomcat?ref=v1.1.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    vpc-id = dependency.vpc.outputs.vpc-id
    load-balancer-security-group-id = dependency.vpc.outputs.load-balancer-security-group-id
    tomcat-security-group-id = dependency.vpc.outputs.tomcat-security-group-id
    load-balancer-subnet-ids = dependency.vpc.outputs.public-subnet-ids
    tomcat-subnet-ids = dependency.vpc.outputs.private-subnet-ids
    ec2-instance-type = "t2.micro"
    aws-region = "us-east-1"
    project-name = "exp-app"
    key-name = "ec2-vms"
}