terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version="~>5"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

