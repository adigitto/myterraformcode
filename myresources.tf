provider "aws" {
  profile = "default"
  region  = "us-east-1" 
}

resource "aws_s3_bucket" "mytfbucket-prod" {
  bucket = "adi-tf-08102020"
  acl    = "private"
}

resource "aws_default_vpc" "my_default_vpc" {}

resource "aws_security_group" "tf_web_security" {
  name        = "tf-security-webservers"
  description = "Terraform learning test security group"

  #Define the ingress rules block
  ingress {
    from_port  = 80
    to_port    = 80
    protocol   = "tcp"
    cidr_blocks = ["192.168.1.64/32"]
  }
  
  ingress {
    from_port  = 443
    to_port    = 443
    protocol   = "tcp"
    cidr_blocks = ["192.168.1.64/32"]
  }
  #Define the egress rules block
  egress {
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    "Terraform" : "true"
  }
}



 
