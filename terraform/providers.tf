terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.13.0"
    }
  }
  required_version = ">= 1.3.0"
}

provider "aws" {
  profile = var.profile
  region  = var.region_master
  alias   = "region-master"
}