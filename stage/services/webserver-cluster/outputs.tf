output "app_lb_address" {
  value = "${module.webserver-cluster.elb_url}"
}