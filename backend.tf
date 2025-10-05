#############################################################
# Backend and Provider config for the Project
#############################################################

terraform {
  backend "s3" {
    bucket = "" # S3 Bucket for the work.
    key    = "aws-security.tfstate"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.15"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.13.1"
    }
  }
}

provider "aws" {
  # can set region and profile or comment them out.
  region  = ""
  profile = ""

  # these will be added to all resources and good for managing the project resources
  default_tags {
    tags = {
      "Application" = "AWS Security"
      "Business"    = "" # I use this tag. remove if you don't want.
    }
  }
}
