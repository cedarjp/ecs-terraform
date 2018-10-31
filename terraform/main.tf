terraform {
  required_version = ">= 0.11.0"

  backend "s3" {
    bucket         = "ecsapp-tfstate-bucket"
    key            = "ecsapp.tfstate.aws"
    region         = "ap-northeast-1"
    dynamodb_table = "ecsapp-lock"
    profile        = "ecsapp"
  }
}

provider "aws" {
  region  = "${var.region}"
  profile = "ecsapp"
}

data "aws_caller_identity" "self" {}
