# AWS provider - allows Terraform to interact with AWS services.
provider "aws" {
  region = local.region
}

terraform {
  required_version = ">=1.0" # Minimum Terraform version required

  required_providers {
    aws = {
      source  = "hashicorp/aws" # Official AWS provider source
      version = "~>5.53"        # Version constraint for the AWS provider
    }
  }
}

