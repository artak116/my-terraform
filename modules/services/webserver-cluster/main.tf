data "terraform_remote_state" "db" {
  backend = "s3"

  config {
    bucket = "terraform-up-running-state"
    key    = "${var.db_remote_state_key}"
    region = "us-east-2"
  }
}

data "terraform_remote_state" "keypair" {
  backend = "s3"

  config {
    bucket = "terraform-up-running-state"
    key    = "${var.keypair_remote_state_key}"
    region = "us-east-2"
  }
}

data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh")}"

  vars {
    server_port = "${var.server_port}"
    db_address  = "${data.terraform_remote_state.db.db_address}"
    db_port     = "${data.terraform_remote_state.db.db_port}"
  }
}

data "aws_availability_zones" "all" {}

resource "aws_security_group" "asg-sg" {
  name = "${var.cluster_name}-asg"

  ingress {
    from_port   = "${var.server_port}"
    protocol    = "tcp"
    to_port     = "${var.server_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = "${var.ssh_port}"
    protocol    = "tcp"
    to_port     = "${var.ssh_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.cluster_name}-asg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "elb-sg" {
  name = "${var.cluster_name}-elb"

  ingress {
    from_port   = "${var.balancer_port}"
    protocol    = "tcp"
    to_port     = "${var.balancer_port}"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }

  tags {
    Name = "${var.cluster_name}-elb"
  }
}

resource "aws_launch_configuration" "example_lg" {
  image_id        = "ami-0f65671a86f061fcd"
  instance_type   = "${var.instance_type}"
  security_groups = ["${aws_security_group.asg-sg.id}"]
  key_name        = "${data.terraform_remote_state.keypair.key_name}"
  user_data       = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "example_asg" {
  launch_configuration = "${aws_launch_configuration.example_lg.id}"
  availability_zones   = ["${data.aws_availability_zones.all.names}"]
  load_balancers       = ["${aws_elb.asg-elb.id}"]
  health_check_type    = "ELB"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"

  tag {
    key                 = "Name"
    propagate_at_launch = true
    value               = "${var.cluster_name}-asg"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_elb" "asg-elb" {
  "listener" {
    instance_port     = "${var.server_port}"
    instance_protocol = "http"
    lb_port           = "${var.balancer_port}"
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    interval            = 30
    target              = "HTTP:${var.server_port}/"
    timeout             = 3
    unhealthy_threshold = 2
  }

  security_groups    = ["${aws_security_group.elb-sg.id}"]
  availability_zones = ["${data.aws_availability_zones.all.names}"]

  tags {
    Name = "${var.cluster_name}-elb"
  }

  lifecycle {
    create_before_destroy = true
  }
}
