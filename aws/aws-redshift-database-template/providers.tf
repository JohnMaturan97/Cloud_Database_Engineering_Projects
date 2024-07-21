terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "jm97"

    workspaces {
      name = "aws-andromeda-jm97-slvr"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.Access_Key_ID
  secret_key = var.Secret_Access_Key
}
