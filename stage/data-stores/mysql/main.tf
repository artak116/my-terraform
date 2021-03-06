provider "aws" {
  region = "us-east-2"
}

module "db" {
  source = "../../../modules/data-stores/mysql"

  db_password      = "stage123456"
  db_instance_name = "staging"
  db_instance_type = "db.t2.micro"
  db_storage_size  = 5
  db_access        = true
}
