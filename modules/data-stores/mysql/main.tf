resource "aws_db_instance" "example" {
  identifier                = "${var.db_instance_name}"
  instance_class            = "${var.db_instance_type}"
  engine                    = "mysql"
  allocated_storage         = "${var.db_storage_size}"
  username                  = "admin"
  password                  = "${var.db_password}"
  publicly_accessible       = "${var.db_access}"
  skip_final_snapshot       = true
  final_snapshot_identifier = "example"

  tags {
    Name = "terraform-example"
  }
}
