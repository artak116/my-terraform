provider "aws" {
  region = "us-east-2"
}

resource "aws_instance" "example" {
  ami = "ami-04c305e118636bc7d"
  instance_type = "t2.micro"

  tags {
    Name = "terraform-example"
  }
}