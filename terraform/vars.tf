variable "vpc_cidr_assignment" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}
variable "public_subnets" {
  default = ["10.0.101.0/24", "10.0.102.0/24"]
}


variable "my_ami" {
  default = "ami-08d4ac5b634553e16"
}

variable "my_instance_type" {
  default = "t2.micro"
}

variable "my_key_name" {
  default = "myec2key"
}
