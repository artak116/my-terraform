provider "aws" {
  region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCuSiaTBRZ4Pf/QZadYIGB2KcjmGJ57+l+JCngUTquQCV0hA6afjKgOt1y2UqAfKn3kB8vdCNmUK1pdGyxtRxD5/f5c0Y8hXqv2KrJM+OjeJb5OYbqtxqvh7KJoyvDzUvzIkYWirdv7QzSxRrcF5lm1CjVURxIujXYNbTlrg3oJ6jpRrh3IOvjC1uKdipKvUvH04lWK1ZYZyoiUvSImWvazXzj2VhbFPwZxWZVK3C6MJr7h6JK1D+iwGCKZzNoES0cPBLZkOsZ2Nde/KM3jEjo9x5t1S/V35barfd1PFNfwDBEBwuY4NCOjmgS+CkWIGI9W0dbdhbfCAJj5WOYuZoqH artak.mac"
  lifecycle {
    prevent_destroy = true
  }
}
