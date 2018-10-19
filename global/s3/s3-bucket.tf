provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "terraform_state_s3" {
  bucket = "terraform-up-running-state"

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = true
  }
}
