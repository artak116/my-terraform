provider "aws" {
  region = "us-east-2"
}

module "webserver-cluster" {
  source = "../../../modules/services/webserver-cluster"

  cluster_name             = "artak-staging"
  server_port              = 8080
  ssh_port                 = 22
  balancer_port            = 80
  db_remote_state_key      = "stage/data-stores/mysql/terraform.tfstate"
  keypair_remote_state_key = "global/keypair/terraform.tfstate"
  instance_type            = "t2.micro"
  min_size                 = 1
  max_size                 = 2
}
