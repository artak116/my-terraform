provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuSiaTBRZ4Pf/QZadYIGB2KcjmGJ57+l+JCngUTquQCV0hA6afjKgOt1y2UqAfKn3kB8vdCNmUK1pdGyxtRxD5/f5c0Y8hXqv2KrJM+OjeJb5OYbqtxqvh7KJoyvDzUvzIkYWirdv7QzSxRrcF5lm1CjVURxIujXYNbTlrg3oJ6jpRrh3IOvjC1uKdipKvUvH04lWK1ZYZyoiUvSImWvazXzj2VhbFPwZxWZVK3C6MJr7h6JK1D+iwGCKZzNoES0cPBLZkOsZ2Nde/KM3jEjo9x5t1S/V35barfd1PFNfwDBEBwuY4NCOjmgS+CkWIGI9W0dbdhbfCAJj5WOYuZoqH artak.mac"
}

resource "aws_instance" "example" {
  ami = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]
  key_name = "deployer-key"

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF
  tags {
    Name = "terraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"

  ingress {
    from_port = "${var.server_port}"
    protocol = "tcp"
    to_port = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port = "${var.ssh_port}"
    protocol = "tcp"
    to_port = "${var.ssh_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-example-sg"
  }
}
