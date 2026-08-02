terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.57.1"
    }
  }

  required_version = ">= 1.5.0"
}

provider "aws" {
  region = "us-east-2"
}