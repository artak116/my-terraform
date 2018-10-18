provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuSiaTBRZ4Pf/QZadYIGB2KcjmGJ57+l+JCngUTquQCV0hA6afjKgOt1y2UqAfKn3kB8vdCNmUK1pdGyxtRxD5/f5c0Y8hXqv2KrJM+OjeJb5OYbqtxqvh7KJoyvDzUvzIkYWirdv7QzSxRrcF5lm1CjVURxIujXYNbTlrg3oJ6jpRrh3IOvjC1uKdipKvUvH04lWK1ZYZyoiUvSImWvazXzj2VhbFPwZxWZVK3C6MJr7h6JK1D+iwGCKZzNoES0cPBLZkOsZ2Nde/KM3jEjo9x5t1S/V35barfd1PFNfwDBEBwuY4NCOjmgS+CkWIGI9W0dbdhbfCAJj5WOYuZoqH artak.mac"
  lifecycle {
    create_before_destroy = true
  }
}

//Launch Configuration
resource "aws_launch_configuration" "example" {
  image_id = "ami-0f65671a86f061fcd"
  instance_type = "t2.micro"
  key_name = "deployer-key"
  security_groups = ["${aws_security_group.instance.id}"]
  user_data = <<EOF
#!/bin/bash
echo "Hello, World" > index.html
nohup busybox httpd -f -p "${var.server_port}" &
EOF
  lifecycle {
    create_before_destroy = true
  }

}

//ASG
resource "aws_autoscaling_group" "example" {
  launch_configuration = "${aws_launch_configuration.example.id}"
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  load_balancers = ["${aws_elb.elb.id}"]
  max_size = 10
  min_size = 1
  desired_capacity = 1
  tag {
    key = "Name"
    propagate_at_launch = true
    value = "terraform-example-asg"
  }


}

//LB
resource "aws_elb" "elb" {
  availability_zones = ["${data.aws_availability_zones.all.names}"]
  security_groups = ["${aws_security_group.elb.id}"]
  "listener" {
    instance_port = "${var.server_port}"
    instance_protocol = "http"
    lb_port = "${var.elb_http_port}"
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 2
    interval = 30
    target = "HTTP:${var.server_port}/"
    timeout = 3
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "terraform-example-lb"
  }
}

//SG
resource "aws_security_group" "instance" {

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

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb" {
  ingress {
    from_port = "${var.elb_http_port}"
    protocol = "tcp"
    to_port = "${var.elb_http_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "terraform-example-lb-sg"
  }

  lifecycle {
    create_before_destroy = true
  }
}