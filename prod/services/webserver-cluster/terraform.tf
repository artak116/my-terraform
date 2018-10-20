terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "terraform-up-running-state"
    dynamodb_table = "terraform-lock-dynamodb"
    region         = "us-east-2"
    key            = "stage/services/webserver-cluster/terraform.tfstate"
  }
}
