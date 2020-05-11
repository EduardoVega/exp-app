remote_state {
  backend = "s3"
  config = {
    bucket         = "exp-app-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "exp-app-terraform-lock-table"
    s3_bucket_tags = {
        Project = "exp-app"
    }
    dynamodb_table_tags = {
        Project = "exp-app"
    }
  }
}