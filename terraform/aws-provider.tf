terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.20.1"
    }
  }
  backend "s3" {
    bucket = "mani-terraform-assignment-s3"
    key    = "state/terraform.tfstate"
    region = "us-east-1"
  }

}

provider "aws" {
  # Configuration options
  region = "us-east-1"
}

