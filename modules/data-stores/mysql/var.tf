variable "db_password" {
  description = "The MySQL Database password"
}

variable "db_instance_name" {
  description = "The name of instance"
}

variable "db_instance_type" {
  description = "The instance type of the RDS instance"
}

variable "db_storage_size" {
  description = "The amount of allocated storage"
}

variable "db_access" {
  description = "Bool to control if instance is publicly accessible"
}
