terraform {
  required_version = ">= 1.5.0"

  backend "s3" {
    bucket         = "my-serverless-tf-state-bucket-1234567890"
    key            = "serverless-expense-api/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "my-serverless-tf-locks"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
