resource "aws_dynamodb_table" "terraform_lock_dynamodb" {
  name = "terraform-lock-dynamodb"
  hash_key = "LockID"
  read_capacity = 20
  write_capacity = 20

  attribute {
    name = "LockID"
    type = "S"
  }

  tags {
    Name = "DynamoDB Terraform State Lock Table"
  }

  lifecycle {
    prevent_destroy = true
  }
}