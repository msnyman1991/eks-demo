terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "terraform-state"
    region         = "eu-west-1"
    key            = "eks-demo-app.tfstate"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}

provider "aws" {
  # default_tags {
  #   tags = {

  #   }
  # }
  region = "eu-west-1"
}