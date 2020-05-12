terraform {
  source = "git@github.com:EduardoVega/exp-app.git//infra-modules/rds?ref=v1.1.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
    aws-region = "us-east-1"
    rds-security-group-id = dependency.vpc.outputs.rds-security-group-id
    rds-subnet-ids = dependency.vpc.outputs.private-subnet-ids
    project-name = "expapp"
}