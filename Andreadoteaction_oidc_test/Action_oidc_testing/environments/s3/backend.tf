module "s3" {
  source = "git@github.com:Andreadote/terraform-modules-series.git//S3_module?ref=v1.7.0"
}

#Backend configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket  = "bootcamp32-dev-179"
    region  = "us-west-2"
    key     = "s3/terraform.tfstate"
    encrypt = true
  }
}

provider "aws" {
  region = "us-west-2"
}