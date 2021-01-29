provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "terraform-state" {

  bucket = var.terraform-state
  acl    = "private"

  tags = {
    Name        = "TFState"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket" "log-bucket" {

  bucket = var.log-bucket
  acl = "private"

  tags = {
    Name = "logbucket"
    Environment = "Dev"
  }
}


