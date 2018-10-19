provider "aws" {
  region = "us-east-2"
}

resource "aws_db_instance" "example" {
  instance_class      = "db.t2.micro"
  engine              = "mysql"
  allocated_storage   = 5
  username            = "admin"
  password            = "${var.db_password}"
  publicly_accessible = false
  skip_final_snapshot = true
  final_snapshot_identifier = "example"

  tags {
    Name = "terraform-example"
  }
}
