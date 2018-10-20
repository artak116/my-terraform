variable "cluster_name" {
  description = "staging, production"
}

variable "server_port" {
  description = "The HTTP port"
}

variable "ssh_port" {
  description = "The SSH Port"
}

variable "balancer_port" {
  description = "The Elastic Load balancer port"
}

variable "db_remote_state_key" {
  description = "The path for the database's remote state in S3"
}

variable "keypair_remote_state_key" {
  description = "The path for the database's remote state in S3"
}

variable "instance_type" {
  description = "The type of EC2 Instances to run (e.g. t2.micro)"
}

variable "min_size" {
  description = "The minimum number of EC2 Instances in the ASG"
}

variable "max_size" {
  description = "The maximum number of EC2 Instances in the ASG"
}
