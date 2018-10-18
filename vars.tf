variable "server_port" {
  description = "Web Server Port"
  default = 8081
}

variable "ssh_port" {
  description = "SSH Port"
  default = 22
}

variable "elb_http_port" {
  description = "HTTP port"
  default = 80
}