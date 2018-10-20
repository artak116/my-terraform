provider "aws" {
  region = "us-east-2"
}

module "db" {
  source = "../../../modules/data-stores/mysql"

  db_password      = "prod123456"
  db_instance_name = "prod"
  db_instance_type = "db.t2.micro"
  db_storage_size  = 7
  db_access        = false
}
