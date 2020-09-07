# No need to write about the provider again since other file has already mentioned it
#provider "aws" {
#  profile = "default"
#  region  = "us-east-1"
#}

resource "aws_vpc" "tf_vpc" {
  cidr_block       = "10.1.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name      = "tf_vpc"
    Terraform = "true"
  }
}

resource "aws_route_table" "tf_routetable1" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Terraform = "true"
  }
}
