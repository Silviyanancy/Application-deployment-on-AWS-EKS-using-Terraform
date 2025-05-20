# To define locals or resuable expressions in terraform.
# Local values are only accessible within the module where they are defined.
locals {
  env         = "Test"       # Environment 
  region      = "us-east-1"  # AWS region
  zone1       = "us-east-1a" # Availability Zone 1
  zone2       = "us-east-1b" # Availability Zone 2
  eks_name    = "EKSDemo"    # Name of the EKS cluster
  eks_version = "1.30"       # Kubernetes version for EKS
}
