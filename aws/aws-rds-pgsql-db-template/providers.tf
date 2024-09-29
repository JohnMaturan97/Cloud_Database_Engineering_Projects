terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "Andromeda101"

    workspaces {
      name = "aws-andromeda-slvr"
    }
  }
}

provider "aws" {
  region     = var.aws_region
  access_key = var.Access_Key_ID
  secret_key = var.Secret_Access_Key
}
