terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "gcs" {
    bucket = "figure-terraform-production"
    prefix = "one-off-chain-infra/axelar/infrastructure/"
  }
}

provider "aws" {
  profile = terraform.workspace
  region = "us-east-1"
}
