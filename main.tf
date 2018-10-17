provider "aws" {
  region = "us-east-2"
}

variable "server_port" {
  description = "Web Server Port"
  default = 8081
}

output "example_public_ip" {
  value = ["${aws_instance.example.public_ip}", "${aws_instance.example.public_dns}"]
}

resource "aws_instance" "example" {
  ami = "ami-05f39e7b7f153bc6a"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${aws_security_group.instance.id}"]

  user_data = <<EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup python -m SimpleHTTPServer ${var.server_port} &
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
  tags {
    default = "true"
  }
}
