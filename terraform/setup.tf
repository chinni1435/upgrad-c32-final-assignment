module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = var.vpc_cidr_assignment

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = true

  tags = {
    Terraform = "true"
    Assignment = "task-1"
  }
}


data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

resource "aws_security_group" "bastion-host-sg" {
  name = "bastion-sg"
  vpc_id = module.vpc.vpc_id

  // To Allow SSH Transport
  ingress {
    from_port = 22
    protocol = "tcp"
    to_port = 22
    cidr_blocks = [
      "${chomp(data.http.myip.body)}/32"]
  }

  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  }

}


resource "aws_security_group" "private-instance-sg" {
  name = "private-instance-sg"
  vpc_id = module.vpc.vpc_id

  // To Allow SSH Transport
  ingress {
    from_port = 0
    protocol = "tcp"
    to_port = 65535
    cidr_blocks  = [var.vpc_cidr_assignment]
  }

  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "public-web-sg" {
  name = "public-web-sg"
  vpc_id = module.vpc.vpc_id

  // To Allow SSH Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = [
      "${chomp(data.http.myip.body)}/32"]
  }

  egress {
  from_port        = 0
  to_port          = 0
  protocol         = "-1"
  cidr_blocks      = ["0.0.0.0/0"]
  }

}


resource "aws_instance" "bashian" {
  ami = var.my_ami
  instance_type = var.my_instance_type
  subnet_id = module.vpc.public_subnets[0]
  key_name = var.my_key_name
  associate_public_ip_address = true


  vpc_security_group_ids = [
    aws_security_group.bastion-host-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {"Name" = "bashian"}

}



resource "aws_instance" "private-jenkins" {
  ami = var.my_ami
  instance_type = var.my_instance_type
  subnet_id = module.vpc.private_subnets[0]
  key_name = var.my_key_name


  vpc_security_group_ids = [
    aws_security_group.private-instance-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {"Name" = "Jenkins"}

}

resource "aws_instance" "private-app" {
  ami = var.my_ami
  instance_type = var.my_instance_type
  subnet_id = module.vpc.private_subnets[0]
  key_name = var.my_key_name


  vpc_security_group_ids = [
    aws_security_group.private-instance-sg.id
  ]
  root_block_device {
    delete_on_termination = true
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {"Name" = "APP"}

}

