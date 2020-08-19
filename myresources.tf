# -------- Provider block ---------#
provider "aws" {
  profile = "default"
  region  = "us-east-1" 
}

# -------- S3 bucket ---------#
resource "aws_s3_bucket" "mytfbucket-prod" {
  bucket = "adi-tf-08102020"
  acl    = "private"
}


# ------- AWS Default VPC --------# 
resource "aws_default_vpc" "my_default_vpc" {}


# --------- Security Group--------#
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

# -------- EC2 Instance ---------- #
resource "aws_instance" "web-instance" {
  count = 2

  ami = "ami-xyz"  # Need to get exact ami-ID
  instance_type = "t2.nano"

  vpc_security_group_ids = [
    aws_security_group.tf_web_security.id
  ]

  tags = {
    "Terraform" : "True"
  }
}


# ------- Elastic IP ------------- #

resource "aws_eip_association" "eip_allocation" {
  instance_id   = aws_instance.web-instance.0.id
  allocation_id = aws_eip.my_instance_eip.id
}

resource "aws_eip" "my_instance_eip" {
  tags = {
    "Terraform" : "true"
  }

}

 
