terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.3.2"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "3.33.0"
    }
  }
}

provider "github" {
  token = ""
}

resource "github_repository" "example" {
  name = "terraform-repo"

  visibility = "private"

}

provider "aws" {
  region  = "us-west-2"
  profile = "armory-sales-dev"
}

resource "aws_instance" "myec2" {
  ami           = "ami-06b1646c2445a079c"
  instance_type = "t2.micro"

  tags = merge(map("Name", "HelloWorld"), local.terratag_added_main)
}

resource "aws_iam_role" "myrole" {
  name = "test_role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF
  tags               = local.terratag_added_main
}
locals {
  terratag_added_main = {"owner"="away"}
}

