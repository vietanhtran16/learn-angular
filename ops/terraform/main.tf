terraform {
  backend "s3" {
    encrypt = true
    key="terraform.tfstate"
  }
}

provider "aws" {
  region = "${var.aws_region}"
}

provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}
