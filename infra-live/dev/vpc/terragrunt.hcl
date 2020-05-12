terraform {
  source = "git@github.com:EduardoVega/exp-app.git//infra-modules/vpc?ref=v1.1.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  aws-region = "us-east-1"
  project-name = "exp-app"
}