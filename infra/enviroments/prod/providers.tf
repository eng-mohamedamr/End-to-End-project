terraform {
  required_version = ">= 1.10.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket  = "mohamedamr-terraform-state-2026"   # existing bucket name
    key     = "envs/dev/terraform.tfstate" # path of the state file inside the bucket
    region  = "eu-north-1"               # region of the bucket
    encrypt = true

    # Native S3 state locking (Terraform >= 1.10), no DynamoDB table needed
    use_lockfile = true
  }
}

provider "aws" {
  region = "eu-north-1"
}
