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
# Below two resources (default) will not create new VPC/Subnets, but create existing ones
resource "aws_default_vpc" "my_default_vpc" {}

# ------- AWS Default Subnets --------# 
resource "aws_default_subnet" "default_subnet_az1" {
  availability_zone = "us-east-1a"
  tags = {
    "Terraform" : "True"
  }
}
resource "aws_default_subnet" "default_subnet_az2" {
  availability_zone = "us-east-1b"
  tags = {
    "Terraform" : "True"
  }
}


# --------- ELB --------------#
resource "aws_elb" "prod_web_alb" {
  name            =  "prod-web-alb"
  instances       =  aws_instance.web-instance.*.id  #note the .*. will use multiple Ec2 instances
  subnets         =  [aws_default_subnet.default_subnet_az1.id, aws_default_subnet.default_subnet_az2.id]
  security_groups =  [aws_security_group.tf_web_security.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http" 
  }
}


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



#------- Elastic IP ------------- #

resource "aws_eip_association" "eip_allocation" {
  instance_id   = aws_instance.web-instance.0.id
  allocation_id = aws_eip.my_instance_eip.id
}

resource "aws_eip" "my_instance_eip" {
  tags = {
    "Terraform" : "true"
  }

}

 
