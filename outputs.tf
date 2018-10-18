//output "example_public_ip" {
////  value = ["${aws_instance.example.public_ip}", "${aws_instance.example.public_dns}"]
////}
output "lb_public_ip" {
  value = "${aws_elb.elb.dns_name}"
}