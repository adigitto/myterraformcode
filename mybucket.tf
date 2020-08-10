provider "aws" {
  profile = "default"
  region  = "us-east-1" 
}

resource "aws_s3_bucket" "mytfbucket" {
  bucket = "adi-tf-08102020"
  acl    = "private"
} 
