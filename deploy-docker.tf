terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "new_instance" {
  ami                    = "ami-04cdc91e49cb06165"
  instance_type          = "t3.micro"
  vpc_security_group_ids = ["${aws_security_group.for_new_instance.id}"]
  user_data = "${file("./docker_in_aws.sh")}"


  tags = {
    Name = "web-app-docker"
  }
}
locals {
  inbound_ports = [22, 80, 443, 8000]
}
resource "aws_security_group" "for_new_instance" {
  name        = "sg-actions"
  description = "For github actions"

  dynamic "ingress" {
    for_each = local.inbound_ports

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
