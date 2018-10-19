variable "server_port" {
  description = "The HTTP port"
  default     = 8080
}

variable "ssh_port" {
  description = "The SSH Port"
  default     = 22
}

variable "balancer_port" {
  description = "The Elastic Load balancer port"
  default     = 80
}
